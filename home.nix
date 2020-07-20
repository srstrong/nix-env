{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv.lib) optionals;
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
