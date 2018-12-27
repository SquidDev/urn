{ nixpkgs ? import <nixpkgs> {}
, enableLuaJit ? false
, lua ? nixpkgs.pkgs.lua
, luajit ? nixpkgs.pkgs.luajit
, readline ? nixpkgs.pkgs.readline
, extraLibraries ? []
}:

let
  inherit (nixpkgs) stdenv;
  ourVersion = "0.7.2";

  # Build a sort of "union package" with all the native dependencies we
  # have: Lua (or LuaJIT), readline, etc. Then, we can depend on this
  # and refer to ${runtime} instead of ${lua}, ${readline}, etc
  runtime = nixpkgs.buildEnv {
    name = "urn-rt-${ourVersion}";
    ignoreCollisions = true;
    paths = if enableLuaJit then
              [ luajit readline ]
            else
              [ lua ];
  };
  dependencies = if extraLibraries == [] then "" else "-with-libraries";
in
  stdenv.mkDerivation rec {
    name = "urn-${ourVersion}${dependencies}";
    version = ourVersion;
    src = ./.;

    buildInputs = [ runtime nixpkgs.pkgs.makeWrapper ];
    # any packages that depend on the compiler have a transitive
    # dependency on the runtime support
    propagatedBuildInputs = buildInputs;

    makeFlags = ["-B"];

    installPhase = ''
    install -Dm755 bin/urn.lua $out/bin/urn
    mkdir -p $out/lib/
    cp -r lib $out/lib/urn
    wrapProgram $out/bin/urn \
      --add-flags "-i $out/lib/urn --prelude $out/lib/urn/prelude.lisp" \
      --add-flags "${nixpkgs.lib.concatMapStringsSep " " (x: "-i ${x.libraryPath}") extraLibraries}" \
      --prefix PATH : ${runtime}/bin/ \
      --prefix LD_LIBRARY_PATH : ${runtime}/lib/
    '';

    meta = with stdenv.lib; {
      homepage = https://squiddev.github.io/urn;
      description = "A lean lisp implementation for Lua";
      license = licenses.bsd3;
    };
    passthru = {
      # useful for getting a nix-shell
      urn-rt = runtime;
    };
  }
