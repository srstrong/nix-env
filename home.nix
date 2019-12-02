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
    a1g
    rg
  ];

  # Configuration
  imports = [
    ../../common/steve/hm-fish.nix
    ../../common/steve/hm-tmux.nix
    ../../common/steve/hm-git.nix
    ../../common/steve/hm-emacs.nix
    ../../common/steve/hm-zsh.nix
    ../../common/steve/hm-direnv.nix
    ../../common/steve/hm-lorri.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
