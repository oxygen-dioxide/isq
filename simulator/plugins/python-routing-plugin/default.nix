{pkgs? import ../../../buildscript/pkgs.nix}:
with pkgs;
let
  python-deps = pypi: with pypi; [ numpy networkx vmprof ];
  # use pypy for performance.
  python = pypy3.withPackages python-deps;
in
pkgs.stdenv.mkDerivation rec {
    name = "isqv2-simulator-python-routing-plugin";
    buildInputs = [ python bash ];
    PYTHONPATH = "${python}/${python.sitePackages}";
    src = ./.;
    inherit python;
    pythonpath = PYTHONPATH;
    installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r $src/src $out/lib/isqv2-simulator-python-routing-plugin
    cp $src/bin/qcis-routing $out/bin/
    substituteAllInPlace $out/bin/qcis-routing
    runHook postInstall
    '';
}
