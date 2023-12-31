{ nodejs
, busybox
, curl
, buildEnv
, dockerTools
, imageName ? "nodejs-base-image"
, imageTag ? "local"
, extraEnv ? []
, extraPkgs ? []
}: let
  bin = buildEnv {
    name = "bin";
    paths = [
      busybox
      curl
      nodejs
    ];
    pathsToLink = [ "/bin" ];
  };
in dockerTools.buildImage {
  name = imageName;
  tag = imageTag;
  copyToRoot = buildEnv {
    name = "webapp-base";
    paths = with dockerTools; [
      bin
      usrBinEnv
      caCertificates
    ] ++ extraPkgs;
  };
  runAsRoot = ''
    #!/bin/sh
    mkdir -pm1777 /tmp
    mkdir -p /app
    corepack enable
  '';
  config = {
    Cmd = [ "/bin/sh" ];
    WorkingDir = "/app";
    Env = extraEnv;
  };
}
