{ mathematica, requireFile }:

mathematica.override {
  source = requireFile {
    name = "Wolfram_14.1.0_LIN.sh";
    hash = "sha256-PCpjwqA6NC+iwvYxddYBlmF5+vl76r+MoIYAL91WFns=";
    message = ''
      Your override for Mathematica includes a different src for the installer,
      and it is missing.
    '';
    hashMode = "flat";
  };
}
