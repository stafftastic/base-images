{ python
, pipenv
, postgresql
, openssl
, busybox
, buildEnv
, dockerTools
, imageName ? "python-base-image"
, imageTag ? "local"
, extraEnv ? []
, extraPkgs ? []
, extraPythonPackages ? ps: []
}: let
  pythonWithPackages = python.withPackages extraPythonPackages;
  bin = buildEnv {
    name = "bin";
    paths = [
      busybox
      pythonWithPackages
      pipenv
      openssl
    ];
    pathsToLink = [ "/bin" ];
  };
in dockerTools.buildImage {
  name = imageName;
  tag = imageTag;
  copyToRoot = buildEnv {
    name = "python-base";
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
  '';
  config = {
    Cmd = [ "/bin/sh" ];
    WorkingDir = "/app";
    Env = extraEnv;
  };
}
