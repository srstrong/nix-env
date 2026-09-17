{ pkgs, inputs, ... }:
let
in
{
  nix.settings.trusted-users = [ "root" "steve" ];

  # Norsk binary cache — previously appended directly to /etc/nix/nix.conf by
  # scripts/nix/install-cache.sh; the markers are kept so that script treats it
  # as already installed.
  nix.extraOptions = ''
    # >>> norsk nix cache (managed by scripts/nix/install-cache.sh) >>>
    extra-substituters = s3://norsk-binary-cache?region=eu-west-1
    extra-trusted-public-keys = norsk-cache-1:KwyoUy3m88th8dXuHPbH1Q8Sa8n0ntZBGGcBZB70dSQ=
    # Silences the redundant flake-config accept prompt; the two lines above are
    # what actually enable the cache.
    accept-flake-config = true
    # <<< norsk nix cache <<<
  '';

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
  # homebrew.onActivation.autoUpdate = true;
  # homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.lockfiles = true;
  homebrew.brewPrefix = "/opt/homebrew/bin"; # M1 - parameterise
  # homebrew.extraConfig = ''
  #   cask "firefox", args: { language: "en-GB" }
  # '';

  homebrew.taps = [
    # "homebrew/core"
    # "homebrew/cask"
    # "homebrew/cask-drivers"
    "ktr0731/evans"
  ];

  homebrew.casks = [
    # "firefox"
    # "discord"
    # "spotify"
    # "yubico-yubikey-manager"
    # "yubico-yubikey-personalization-gui"
    "1password-cli"
    "rancher"
    "db-browser-for-sqlite"
    "temurin"
  ];

  homebrew.brews = [
    "gh"
    "evans"
    "virt-manager"
    "telnet"
    "c-kermit"
    "derailed/k9s/k9s"
    "mosh"
    "freerdp"
    "xterm"
    "pipx"
    "imagemagick"
    "git-filter-repo"
    "kopia"
    "restic"
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
