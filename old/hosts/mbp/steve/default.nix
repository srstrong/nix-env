{ config, pkgs, lib, ... }:

{
  imports =
    [ #./yabai.nix
    ];

  services.skhd = {
    enable = false; #true;
    skhdConfig = builtins.readFile ./dotfiles/skhdrc;
  };
}
