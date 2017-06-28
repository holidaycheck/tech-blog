with import (fetchTarball https://github.com/nixos/nixpkgs/tarball/c2dce6a7459f87e499e976dad2c741437cad8fd5) { };

let jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    ruby = ruby_2_2;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation rec {
    name = "jekyll_env";
    buildInputs = [ jekyll_env ];

    shellHook = ''
      jekyll serve --watch
    '';
  }
