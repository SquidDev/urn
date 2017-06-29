with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "urn";
  version = "0.3.1";
  src = ./.; # oh nix
  buildInputs = [ lua makeWrapper ];

  installPhase = ''
  install -Dm755 bin/urn.lua $out/bin/urn
  mkdir -p $out/lib/
  cp -r lib $out/lib/urn
  wrapProgram $out/bin/urn \
    --add-flags "-i $out/lib/urn --prelude $out/lib/urn/prelude.lisp" \
    --prefix PATH : ${lua}/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://squiddev.github.io/urn;
    description = "A lean lisp implementation for Lua";
    license = licenses.bsd3;
  };
}
