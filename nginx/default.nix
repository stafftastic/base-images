{ lib
, pkgs
, nginx
, busybox
, buildEnv
, callPackage
, dockerTools
, imageName ? "nginx-base-image"
, imageTag ? "local"
, extraEnv ? []
, extraPkgs ? []
, extraNginxConfig ? ""
, extraHttpConfig ? ""
, extraServerConfig ? ""
}: let
  config = {
    nginxConf = callPackage ./config/nginx-conf.nix {
      inherit extraNginxConfig extraHttpConfig extraServerConfig;
    };
  };
  bin = buildEnv {
    name = "bin";
    paths = [
      busybox
      nginx
    ] ++ extraPkgs;
    pathsToLink = [ "/bin" ];
  };
in dockerTools.buildImage {
  name = imageName;
  tag = imageTag;
  copyToRoot = buildEnv {
    name = "nginx-base";
    paths = with dockerTools; [
      bin
      usrBinEnv
      caCertificates
      fakeNss
    ];
  };
  runAsRoot = ''
    #!/bin/sh
    mkdir -pm1777 /tmp
    mkdir -p /entrypoint.d /var/cache/nginx /app
  '';
  config = {
    Cmd = [ "/bin/nginx" "-e" "/dev/null" "-c" config.nginxConf ];
    WorkingDir = "/app";
    Env = extraEnv;
  };
}
