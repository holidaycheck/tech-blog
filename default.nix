{ pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs/tarball/eabc38219184cc3e04a974fe31857d8e0eac098d) { } }:

let 
  inherit (pkgs) stdenv bundlerEnv lib;
  jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    ruby = pkgs.ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation rec {
    src = lib.cleanSource ./.;
    name = "jekyll_env";

    buildInputs = [ jekyll_env ];

    doCheck = true;

    checkPhase = ''
      ./test.sh
    '';

    buildPhase = "true";

    installPhase = ''
      mkdir $out
      jekyll build --destination $out
    '';

    shellHook = ''
      JEKYLL_ENV=local jekyll serve --config _config.yml,_config_local.yml --watch --future
    '';
  }