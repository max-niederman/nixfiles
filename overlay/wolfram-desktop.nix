{ mathematica, requireFile }:

mathematica.override {
  source = requireFile {
    name = "WolframDesktop_14.0.0_BNDL_LINUX.sh";
    hash = "sha256-UYCrXD++KwMyJcYJ1T/LwmhnrhLcI5u+uMq1LX9qcpw=";
    message = ''
      Your override for Mathematica includes a different src for the installer,
      and it is missing.
    '';
    hashMode = "flat";
  };
}
