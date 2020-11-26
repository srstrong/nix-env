{ config, pkgs, lib, ... }:

{
  imports =
    [ ./yabai.nix
    ];

  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ./dotfiles/skhdrc;
  };
}
