{ lib, stdenv, fetchurl, appimageTools, makeDesktopItem }:

let
  pname = "advantagescope";
  version = "3.1.0";

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "AdvantageScope";
    desktopName = "AdvantageScope";
    comment = "Robot telemetry viewer for FRC teams.";
    icon = "advantagescope";
    exec = "advantagescope %u";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Mechanical-Advantage/AdvantageScope/main/icons/window-icon.png";
    hash = "sha256-gqcCqthqM2g4sylg9zictKwRggbaALQk9ln/NaFHxdY=";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

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
    install -D "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -D ${icon} $out/share/pixmaps/remnote.png
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
