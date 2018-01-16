---
layout: post
title:  "Nix in Practice: Providing Dependencies"
date: 2017-11-14 14:03:00 +0200
categories: nix
author_name: Stefan Lau
author_url : /author/stefanlau
author_avatar: stefanlau
read_time : 20
show_related_posts: false
square_related:
feature_image: posts/2017-11-01-nixcon2017/nixos-bg.jpg
---

This is the first of multiple posts about how you can use [Nix][nix] to
solve common problems of developers. We will focus on the solution first, so
you can take advantage of it immediately and will provide a short explanation
of this approach for the interested. Please note that we recommend to read
the [introduction into Nix][introduction] first. The only prerequesite to this
tutorial is that you have [installed Nix][install] on your system. Also we
won't focus on the details of the Nix language and how the syntax works, if you
are interested in that have a look at [this blog post][pill basics].

The question we will focus on in this post is: How to provide dependencies (compilers,
runtimes, etc.) which

- are provided for the development of a single project only
- have fixed versions on all systems
- dont change over time

The solution consists of five steps:

- Step 1: Create a `default.nix` file in your projects folder with the following
  contents.

  ```nix
  let
    hostPkgs = import <nixpkgs> {};
    nixpkgs = (hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      rev = "!some-revision!";
      sha256 = "!sha256!";
    });
  in
  with import nixpkgs {};
  stdenv.mkDerivation {
    name = "my-shell";
    buildInputs = [];
  }
  ```

- Step 2: Replace `!some-revision!` in your `default.nix` by a commit hash from
  the [nixpkgs-channels][nixpkgs-channels-nixpkgs-unstable] repository. Using the latest
  commit from the `nixpkgs-unstable` branch will work fine most of the time.

- Step 3: Run `nix-shell -p nix-prefetch-git --run "nix-prefetch-git --url
  https://github.com/NixOS/nixpkgs-channels.git --rev !some-revision!"`,
  where you replace `!some-revision!` by the git revision you chose. It will
  take some time to download the `nixpkgs-channels` revision from github and
  then leave you with output which contains:

  ```
  ...
  hash is 0vss6g2gsirl2ds3zaxwv9sc6q6x3zc68431z1wz3wpbhpw190p5
  ...
  ```

  Replace `!sha256!` in your `default.nix` with this hash.

- Step 4: Look for all the dependencies you need in the
  [NixOS package search][package search] and add them to the `buildInputs`
  list. You need to add the value from the "attribute name" column.
  Commas or quotes are not necessary.

  An example for a project where you need Java 8 could in the end look
  like this:

  ```nix
  let
    hostPkgs = import <nixpkgs> {};
    nixpkgs = (hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      rev = "1e3995d3ea35f9e4f36bcd18235958759deeb64a";
      sha256 = "1qn7s5369znh9igj5ysrdakkc0hn5wqcmkryv014y65821b87kv4";
    });
  in
  with import nixpkgs {};
  stdenv.mkDerivation {
    name = "my-shell";
    buildInputs = [ openjdk8 ];
  }
  ```

- Step 5: Run `nix-shell` in your projects folder. This should drop you into a shell with the
  dependencies you defined available in `PATH`. Done. You can now commit the
  `default.nix` and run `nix-shell` on every system that you want to run your
  project on and it will provide exactly the same dependencies there. If you
  want to exit the shell, just use `CTRL+D`.

A good use-case could be your CI system. You can execute commands inside the
`nix-shell` using the `--run` parameter. So given your CI server has Nix installed
you could run `nix-shell --run "!your-test-command!"` and the same dependencies
will be used for testing as on your local machine.

## Wait, What Did I Just Do?

You started to describe your project or application as a Nix package
that depends on a specific version of the main `nixpkgs` repository. But lets pick the
`default.nix` apart one-by-one:

```nix
hostPkgs = import <nixpkgs> {};
```

This imports the `nixpkgs` version of your host system. `nixpkgs` is a collection
of package descriptions that is groomed by the Nix maintainers. A version of this
will be installed during the Nix installation procedure. This version
can be updated by running `nix-channel --update` in your shell, so it could always
contain different (versions of) packages. This is why we only use it to fetch a
specific snapshot of these package descriptions. This is done by the next few lines:

```nix
nixpkgs = (hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "<TODO>";
    sha256 = "<TODO>";
});
```

This will fetch a specific commit of the `nixpkgs-channels` repository. To verify
that we have actually fetched the same version of this repository as before, we have to specify
a sha256 hash. The hash is recursively calculated from the fetched files and compared to
the one we specified in the `default.nix` file. Now we want to make the package descriptions
inside the snapshot available for use, which we do by importing the snapshot.

```nix
with import nixpkgs {};
```

This will return a function, which we execute on an empty attribute set (`{}`).
We could pass arguments here, but for our use case, we don't need any.
Executing the function will in turn return an attribute set. The package
descriptions are attributes on this attribute set. This is why we used the
attribute name column from the package search to define our dependencies. Using
`with` we actually bring all these attributes into scope, so we don't have to
adress them all using dot notation like this: `pkgs.openjdk8`.

```nix
stdenv.mkDerivation {
    name = "my-shell";
    buildInputs = [ openjdk8 ];
}
```

`mkDerivation` is used to describe the build of a package. So a "derivation" is
basically a description of a package build. As every package needs to have a name,
we define one here. The name is not really relevant for our use case, but it will
become important once you actually build a package. `buildInputs` is used to define
the build and runtime dependencies of your package. In our case we only use it in
combination with `nix-shell`, which is a command to drop you into a shell, which
installs those dependencies and puts them into the `PATH`. Just inspect your environment
using `echo $PATH` and `which java` to see that all of them come from the
`/nix/store` directory. `nix-shell`, when executed without arguments, will work
on top of your global binaries. You can also try running `nix-shell --pure` which
will drop you into a shell which does not inherit from the host environment. This is
useful to reduce interference between host environment and your application.

Now you have the ability to install different versions of packages only for the projects
where you need them and not globally for your whole system. This is already a very powerful
tool in the hands of a developer. In some cases you need to have an even more specific
environment for your application. This is what the next post will be about: The `shellHook`, a
method to extend your `nix-shell` command.

[nix]: https://nixos.org/nix/
[pill basics]: https://nixos.org/nixos/nix-pills/basics-of-language.html
[introduction]: https://nixos.org/nix/manual/#chap-introduction
[install]: https://nixos.org/nix/manual/#ch-installing-binary
[nixpkgs-channels-nixpkgs-unstable]: https://github.com/NixOS/nixpkgs-channels/tree/nixpkgs-unstable
[package search]: https://nixos.org/nixos/packages.html
