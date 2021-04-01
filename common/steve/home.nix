{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv.lib) optionals;

  #erlangReleases = builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.18-devel.tar.gz;

  erlangReleases = builtins.fetchGit {
    url = "/Users/steve/dev/nixpkgs-nixerl";
    #ref = "master";
    #rev = "efb3975b312ccbbbae2ce9702c6f3e9fbc9fdeaf";
  };

  purerlReleases =
    builtins.fetchGit {
      url = "https://github.com/purerl/nixpkgs-purerl.git";
      ref = "master";
      rev = "01820500971cf0772a505ca055a9fd58c8729320";
    };

  purerlSupport =
    builtins.fetchGit {
      name = "purerl-support-packages";
      url = "git@github.com:id3as/nixpkgs-purerl-support.git";
      rev = "1bb777de71b0532c961de68a8ccd24709b93318d";
    };

  id3asPackages =
    builtins.fetchGit {
      name = "id3as-packages";
      url = "git@github.com:id3as/nixpkgs-private.git";
      rev = "3ebb89abfd4dc05885e90ad6d2980ea1b38f9cfe";
      ref = "v3";
    };

  pls = nixpkgs.nodePackages.purescript-language-server.override {
      version = "0.15.0";
      src = builtins.fetchurl {
        url = "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.15.0.tgz";
      };
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import purerlReleases)
        (import purerlSupport)
        (import erlangReleases)
        (import id3asPackages)
      ];
    };

  erlangChannel = nixpkgs.nixerl.erlang-23-2-1.overrideScope' (self: super: {
  });

in
{
  # Packages
  home.packages = with pkgs; [
    # GNU > BSD :)
    coreutils

    alacritty
    kitty

    # Useful for system administration
    htop
    iftop
    wget
    rsync

    # Development
    autoconf
    ncurses6
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
    #stack
    ghc
    gcc10
    ccls # C language server

    erlangChannel.erlang
    erlangChannel.rebar3
    erlangChannel.erlang-ls

    nixpkgs.purerl-support.purescript-0-14-0
    nixpkgs.purerl-support.spago-0-16-0
    nixpkgs.purerl-support.dhall-json-1-5-0
    nixpkgs.purerl-support.purty-7-0-0
    nixpkgs.purerl-support.psa-0-8-2
    nixpkgs.purerl.purerl-0-0-8
    pls

    # inetutils
  ] ++ optionals stdenv.isLinux [
                 glibcLocales
       ]
    ++ optionals stdenv.isDarwin [
                 darwin.apple_sdk.frameworks.Security
                 darwin.apple_sdk.frameworks.Carbon
                 darwin.apple_sdk.frameworks.Cocoa
                 darwin.apple_sdk.frameworks.AGL
       ];

  # Configuration
  imports = [
    ./hm-fish.nix
    ./hm-tmux.nix
    ./hm-git.nix
    ./hm-emacs.nix
    ./hm-zsh.nix
    ./hm-direnv.nix
    ./hm-lorri.nix
  ];

  home.file = {
    ".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;
    ".alacritty.yml".source = ./dotfiles/alacritty.yml;
    ".ssh/config".source = ./dotfiles/ssh_config;
    "Library/Application\ Support/erlang_ls".source = ./dotfiles/erlang-ls-config.yaml;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
