{ pkgs, inputs, ... }:
let
in
{
  nix.settings.trusted-users = [ "root" "steve" ];
  services.nix-daemon.enable = true;
  nix.configureBuildUsers = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.steve.shell = pkgs.zsh;
  users.users.steve.home = "/Users/steve";

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };

    screencapture.location = "/tmp";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    NSGlobalDomain._HIHideMenuBar = false;
    NSGlobalDomain.NSWindowResizeTime = 0.1;

  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.lockfiles = true;
  homebrew.brewPrefix = "/opt/homebrew/bin"; # M1 - parameterise
  homebrew.extraConfig = ''
    cask "firefox", args: { language: "en-GB" }
  '';

  homebrew.taps = [
    "homebrew/core"
    "homebrew/cask"
    "homebrew/cask-drivers"
    "ktr0731/evans"
    "kak-lsp/kak-lsp"
  ];

  homebrew.casks = [
    # "firefox"
    # "discord"
    # "spotify"
    # "yubico-yubikey-manager"
    # "yubico-yubikey-personalization-gui"
  ];

  homebrew.brews = [
    "evans"
    "kakoune"
    "kak-lsp/kak-lsp/kak-lsp"
  ];

  homebrew.masApps = {
    # WireGuard = 1451685025;
    # YubicoAuthenticator = 1497506650;
  };

  launchd.user.agents.nginx = {
    command = "${pkgs.nginx}/bin/nginx -e /tmp/nginx/error.log -p /tmp -c ~/.nginx/config";
    path = [pkgs.nginx];
    serviceConfig = {
      KeepAlive = true;
    };
  };
}
