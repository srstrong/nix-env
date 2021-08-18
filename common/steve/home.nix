{ config, lib, pkgs, hostOs, ... }:

let
  inherit (pkgs.stdenv);

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

    # inetutils
  ] ++ lib.optionals stdenv.isLinux [
                 glibcLocales
       ]
    ++ lib.optionals stdenv.isDarwin [
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
  }
  //
  (if hostOs == "darwin" then {
    "Library/Application\ Support/erlang_ls".source = ./dotfiles/erlang-ls-config.yaml;
  }
   else {
     ".erlang_ls".source = ./dotfiles/erlang-ls-config.yaml;
   });

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
