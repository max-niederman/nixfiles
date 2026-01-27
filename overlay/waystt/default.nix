{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  git,
  alsa-lib,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "waystt";
  version = "0.3.1-unstable-2025-10-06";

  src = fetchFromGitHub {
    owner = "sevos";
    repo = "waystt";
    rev = "195a4eca64c452ae61e3b76073842bab7316189d";
    hash = "sha256-UFQn151U7JtnlERjG1hoYDK3cMPvB5QxhKhW3ayYeOc=";
  };

  cargoHash = "sha256-j3i9XyoUl0E8K330p/iiKw7iLiWeDW+S57kZM0AshIw=";

  nativeBuildInputs = [
    pkg-config
    cmake
    git
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    openssl
  ];

  meta = {
    description = "Minimal signal-driven speech-to-text for Wayland";
    homepage = "https://github.com/sevos/waystt";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "waystt";
    platforms = lib.platforms.linux;
  };
}
