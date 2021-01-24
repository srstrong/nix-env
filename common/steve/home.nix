{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv.lib) optionals;

  erlangReleases = builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.18-devel.tar.gz;

  purerlReleases =
    builtins.fetchGit {
      url = "https://github.com/purerl/nixpkgs-purerl.git";
      ref = "master";
      rev = "547e2ef774c69d33c7fcb5cd140e50c936681846";
    };

  id3asPackages =
    builtins.fetchGit {
      name = "id3as-packages";
      url = "git@github.com:id3as/nixpkgs-private.git";
      rev = "3ebb89abfd4dc05885e90ad6d2980ea1b38f9cfe";
      ref = "v3";
    };

  pls = nixpkgs.nodePackages.purescript-language-server.override {
      version = "0.14.4";
      src = builtins.fetchurl {
        url = "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.14.4.tgz";
      };
    };

  emacs-overlay =
    builtins.fetchGit {
      url =
        "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "c19934e5e2b500e0418e562e164c8c90a961d3f9";
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import purerlReleases)
        (import erlangReleases)
        (import id3asPackages)
        (import emacs-overlay)
      ];
    };

  erlangChannel = nixpkgs.nixerl.erlang-23-2-1.overrideScope' (self: super: {
    erlang = super.erlang.override {
      wxSupport = false;
    };
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

    nixpkgs.id3as.purescript-0-13-8
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
