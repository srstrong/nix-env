{ config, pkgs, ... }:

{
  # Packages
  home.packages = with pkgs; [

    # GNU > BSD :)
    coreutils

    # Useful for system administration
    htop
    wget

    # Development
    gitAndTools.tig
    dhall
    ag
    ripgrep 
  ];

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
