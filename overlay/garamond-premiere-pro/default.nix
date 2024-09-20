{ stdenv }:

stdenv.mkDerivation {
  name = "garamond-premiere-pro";
  src = ./garamond-premiere-pro.tar.xz;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp */*.otf $out/share/fonts
  '';
}