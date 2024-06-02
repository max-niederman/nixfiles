{ python3Packages, plover, fetchFromGitHub, pkg-config, wayland }:

let
  plover-stroke = python3Packages.buildPythonPackage rec {
    pname = "plover_stroke";
    version = "1.1.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-3gOyP0ruZrZfaffU7MQjNoG0NUFQLYa/FP3inqpy0VM=";
    };
  };

  rtf-tokenize = python3Packages.buildPythonPackage rec {
    pname = "rtf_tokenize";
    version = "1.0.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "XD3zkNAEeb12N8gjv81v37Id3RuWroFUY95+HtOS1gg=";
    };
  };

  pywayland_0_4_7 =
    python3Packages.pywayland.overridePythonAttrs
    (oldAttrs: rec {
      pname = "pywayland";
      version = "0.4.7";

      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "0IMNOPTmY22JCHccIVuZxDhVr41cDcKNkx8bp+5h2CU=";
      };

      doCheck = false;
    });
in
  plover.dev.overridePythonAttrs
  (oldAttrs: {
    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      rev = "fd5668a3ad9bd091289dd2e5e8e2c1dec063d51f";
      sha256 = "2xvcNcJ07q4BIloGHgmxivqGq1BuXwZY2XWPLbFrdXg=";
    };

    propagatedBuildInputs =
      oldAttrs.propagatedBuildInputs
      ++ [
        plover-stroke
        rtf-tokenize
        pywayland_0_4_7
      ];

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkg-config];
    doCheck = false; # TODO: get tests working

    postPatch = ''
      sed -i /PyQt5/d setup.cfg
      substituteInPlace plover_build_utils/setup.py \
        --replace "/usr/share/wayland/wayland.xml" "${wayland}/share/wayland/wayland.xml"
    '';
  })