{ lib, stdenv, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "advantagescope";
  version = "3.1.0";

  src = lib.attrsets.getAttr stdenv.hostPlatform.system {
    x86_64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-x64-v${version}.AppImage";
      hash = "sha256-idsDg5gMlCVvH1f+njgUSk7uOWhMC5yum6RBYQi3aac=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-arm64-v${version}.AppImage";
      hash = "sha256-WaWByC+oqfbfi8ZVykW/a19dEFJ7Jmqd7YvMJPZYpvk=";
    };
  };

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Robot telemetry viewer for FRC teams.";
    homepage = "https://github.com/Mechanical-Advantage/AdvantageScope";
    license = licenses.mit;
    mainProgram = "advantagescope";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ max-niederman ];
  };
}