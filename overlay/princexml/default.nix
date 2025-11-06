{ autoPatchelfHook, fetchurl, fontconfig, glibc, stdenv }:

stdenv.mkDerivation rec {
  pname = "princexml";
  version = "16.1";
  src = fetchurl {
    url = "https://www.princexml.com/download/prince-${version}-linux-generic-x86_64.tar.gz";
    hash = "sha256-Ssy2a32pPn5DFUBUAX6d3rhID4IKqbt9atqVRVy9RAQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    fontconfig
    glibc
  ];

  installPhase = ''
    ./install.sh $out
    ln -sf /var/lib/prince/license.dat $out/lib/prince/license/license.dat
  '';
}