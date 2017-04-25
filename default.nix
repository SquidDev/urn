with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "urn";
  version = "0.3.1";
  src = ./.; # oh nix
  buildInputs = [ lua luajit ];

  meta = with stdenv.lib; {
    homepage = https://squiddev.github.io/urn;
    description = "A lean lisp implementation for Lua";
    license = licenses.bsd3;
  };
}
