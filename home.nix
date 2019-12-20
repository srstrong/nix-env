{ config, pkgs, ... }:

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
    dhall
    ag
    ripgrep
  ];

  # Configuration
  imports = [
    ../../dev/nix-env/steve/hm-fish.nix
    ../../dev/nix-env/steve/hm-tmux.nix
    ../../dev/nix-env/steve/hm-git.nix
    ../../dev/nix-env/steve/hm-emacs.nix
    ../../dev/nix-env/steve/hm-zsh.nix
    ../../dev/nix-env/steve/hm-direnv.nix
    ../../dev/nix-env/steve/hm-lorri.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
