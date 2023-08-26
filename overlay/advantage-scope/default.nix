{ linkFarm, fetchurl, fetchFromGitHub, buildNpmPackage,  electron, python3, makeWrapper, makeDesktopItem }:

let
  ffmpegStatic = linkFarm "ffmpeg-static" [
    {
      name = "ffmpeg-mac-x64";
      path = fetchurl {
        url = "https://github.com/eugeneware/ffmpeg-static/releases/download/b5.0.1/darwin-x64";
        hash = "sha256-xtbwc0Vm+y5HNKqxhCQFzZ/Dsy02wxJbjCogd7xgXTw=";
      };
    }
    {
      name = "ffmpeg-mac-arm64";
      path = fetchurl {
        url = "https://github.com/eugeneware/ffmpeg-static/releases/download/b5.0.1/darwin-arm64";
        hash = "sha256-KywPVx9kTwMf3etg8h01Yptp9cAszL6IqOY5T8dDWs4=";
      };
    }
    {
      name = "ffmpeg-linux-x64";
      path = fetchurl {
        url = "https://github.com/eugeneware/ffmpeg-static/releases/download/b5.0.1/linux-x64";
        hash = "sha256-xIeGclaNrChKU7vcIvd7iQf2dniX1q+6fq3OoKVysoQ=";
      };
    }
    {
      name = "ffmpeg-linux-arm64";
      path = fetchurl {
        url = "https://github.com/eugeneware/ffmpeg-static/releases/download/b5.0.1/linux-arm64";
        hash = "sha256-ECg68lj5ZPXHBU1Eb7hSSGo0jJkhd2fO9AGLfrLIw24=";
      };
    }
    {
      name = "ffmpeg-win-x64.exe";
      path = fetchurl {
        url = "https://github.com/eugeneware/ffmpeg-static/releases/download/b5.0.1/win32-x64";
        hash = "sha256-xx/L7JMcgQ3M1GgmxZEpE583gCne43LyAPErbx2sV1g=";
      };
    }
    {
      name = "ffmpeg-win-arm64.exe";
      path = fetchurl {
        url = "https://github.com/eugeneware/ffmpeg-static/releases/download/b5.0.1/win32-ia32";
        hash = "sha256-wFyZuLRNJ1j0n8ntqp4Q+2WaWAhHx+e95nNKOUor1Pg=";
      };
    }
  ];

  desktopItem = makeDesktopItem {
    name = "advantagescope";
    exec = "advantagescope %U";
    desktopName = "AdvantageScope";
  };
in
buildNpmPackage rec {
  pname = "advantage-scope";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "Mechanical-Advantage";
    repo = "AdvantageScope";
    rev = "v${version}";
    hash = "sha256-RWBPE9kApP9j8muCkUR7Md2vp1ytJua5m7dazrf882s=";
  };

  postPatch = ''
    cp -r ${ffmpegStatic} ffmpeg
  '';

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  preBuild = ''
    npm pkg set homepage=https://github.com/Mechanical-Advantage/AdvantageScope
  '';

  buildPhase = ''
    runHook preBuild

    npm run compile
    npm exec electron-builder -- \
      build \
      --dir \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    mkdir $out

    pushd dist/linux-unpacked
    mkdir -p $out/opt/AdvantageScope
    cp -r locales resources{,.pak} $out/opt/AdvantageScope
    popd

    makeWrapper '${electron}/bin/electron' "$out/bin/advantagescope" \
      --add-flags $out/opt/AdvantageScope/resources/app.asar \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
    
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  npmDepsHash = "sha256-IG9U7gUUHmMtnma2g0gk8VnypwTAene8zM5tfdq+K5s=";
}
