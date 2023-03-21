args@{ config, pkgs, lib, hostOs, ... }:

let
  darwinOpts = {};

  linuxOpts = {
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  };

  osOpts = if hostOs == "darwin" then darwinOpts
           else linuxOpts;
in
{
  imports =
    [ (import ./steve args)
    ];

  # Set your time zone.
  time.timeZone = "Europe/London";

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
  ];

} // osOpts
