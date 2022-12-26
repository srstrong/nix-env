{ config, pkgs, lib, hostOs, ... }:
let
  linuxUserOpts = if hostOs == "linux" then { isNormalUser = true; }
                  else {};
in
{
  imports = if hostOs == "darwin" then [ <home-manager/nix-darwin>
                                       ]
            else [ <home-manager/nixos>
                 ];

  users.users.steve = {
    home = if hostOs == "darwin" then "/Users/steve"
           else "/home/steve";
    shell = "${pkgs.zsh}/bin/zsh";
  } // linuxUserOpts;

  home-manager.users.steve = import ./home.nix { inherit config pkgs lib hostOs; };
}
