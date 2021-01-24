{ config, pkgs, lib, ... }:

{
  imports = [ <home-manager/nix-darwin>
            ];

  users.users.steve = {
    home = "/Users/steve";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager.users.steve = import ./home.nix { inherit config pkgs lib; };
}
