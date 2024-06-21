{ mathematica, requireFile }:

mathematica.override {
  source = requireFile {
    name = "WolframDesktop_14.0.0_BNDL_LINUX.sh";
    sha256 = "0ip26j2h11n1kgkz36rl4akv694yz65hr72q4kv4b3lxcbi65b3p";
    message = ''
      Your override for Mathematica includes a different src for the installer,
      and it is missing.
    '';
    hashMode = "recursive";
  };
}
