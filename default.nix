{ pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs-channels/tarball/dafdaa98a5c35e08a9deeabfb7c5d08c10271c3c) { } }:

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