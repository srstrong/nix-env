{ config, pkgs, lib, ... }:

{
  imports =
    [ ./yabai.nix
    ];

  services.skhd = {
    enable = false;
    skhdConfig = builtins.readFile ./dotfiles/skhdrc;
  };
}
