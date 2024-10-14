{ stdenv }:

stdenv.mkDerivation {
  name = "garamond-premier-pro";
  src = ./garamond-premier-pro.tar.xz;

  installPhase = ''
    mkdir -p $out/share/fonts/{opentype,truetype}
    cp */*.otf $out/share/fonts/opentype
    cp */*.ttf $out/share/fonts/truetype
  '';
}