{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv.lib) optionals;

  erlangReleases = builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.14-devel.tar.gz;

  purerlReleases =
    builtins.fetchGit {
      url = "https://github.com/purerl/nixpkgs-purerl.git";
      ref = "master";
      rev = "547e2ef774c69d33c7fcb5cd140e50c936681846";
    };

  purerlSupport =
    builtins.fetchGit {
      url = "https://github.com/id3as/nixpkgs-purerl-support.git";
      ref = "master";
      rev = "c9a9140db5112e74030763292dc93de25adb3482";
    };

  id3asPackages =
    builtins.fetchGit {
      name = "id3as-packages";
      url = "git@github.com:id3as/nixpkgs-private.git";
      rev = "b62ac1a4382826478a3e5e3293d42dc1c60e25c1";
      ref = "v2";
    };

  pls = nixpkgs.nodePackages.purescript-language-server.override {
      version = "0.13.5";
      src = builtins.fetchurl {
        url = "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.13.5.tgz";
        sha256 = "0jr3hfa4ywb97ybrq4b64pbngwd1x297vppps7cqf4mmiwz9chb9";
      };
    };

  emacs-overlay =
    builtins.fetchGit {
      url =
        "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "29138420e18e2480f674663476663cffc6548fb4";
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import purerlSupport)
        (import purerlReleases)
        (import erlangReleases)
        (import id3asPackages)
        (import emacs-overlay)
      ];
    };

in
{
  # Packages
  home.packages = with pkgs; [
    # GNU > BSD :)
    coreutils

    # Useful for system administration
    htop
    iftop
    wget

    # Development
    gitAndTools.tig
    git-lfs
    dhall
    ag
    ripgrep
    fzf
    jq
    python27Packages.jsmin
    websocat
    zlib.dev
    stack
    ghc

    nixpkgs.nixerl.erlang-23-0-3.erlang
    nixpkgs.nixerl.erlang-23-0-3.rebar3

    nixpkgs.id3as.purescript-0-13-6
    nixpkgs.purerl-support.erlang_ls-0-4-1
    pls

    # inetutils
  ] ++ optionals stdenv.isLinux [ glibcLocales ] ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Configuration
  imports = [
    ./steve/hm-fish.nix
    ./steve/hm-tmux.nix
    ./steve/hm-git.nix
    ./steve/hm-emacs.nix
    ./steve/hm-zsh.nix
    ./steve/hm-direnv.nix
    ./steve/hm-lorri.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
