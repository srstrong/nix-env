{ config, pkgs, inputs, nix-env-config, private, ... }:

let
  mailAddr = name: domain: "${name}@${domain}";
  primaryEmail = mailAddr "steve" "srstrong.com";
  fullName = "Steve Strong";

in
{
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = 4;
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;
  services.nix-daemon.enable = true;

  nixpkgs.overlays = [
    (import ../overlays)
  ];

  nix.settings.trusted-users = [ "root" "steve" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = with pkgs; [
    zsh
    gcc
    kitty
  ];
  environment.variables = { GH_TOKEN = private.gh_token; };
  programs.bash.enable = false;
  programs.zsh.enable = true;

  time.timeZone = "Europe/London";
  users.users.steve.shell = pkgs.zsh;
  users.users.steve.home = "/Users/steve";
  nix.configureBuildUsers = true;

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

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    emacs-all-the-icons-fonts
    fira-code
    font-awesome
    inconsolata
#    nerdfonts
    roboto
    roboto-mono
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  ############
  # Homebrew #
  ############
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
  ];

  homebrew.masApps = {
    # WireGuard = 1451685025;
    # YubicoAuthenticator = 1497506650;
  };

#  services.skhd.enable = true;
#  services.skhd.skhdConfig = builtins.readFile ../conf.d/skhd.conf;

#  services.yabai = {
#    enable = true;
#    package = pkgs.yabai;
#    enableScriptingAddition = true;
#    config = {
#      window_border = "on";
#      window_border_width = 5;
#      active_window_border_color = "0xff81a1c1";
#      normal_window_border_color = "0xff3b4252";
#      focus_follows_mouse = "autoraise";
#      mouse_follows_focus = "off";
#      mouse_drop_action = "stack";
#      window_placement = "second_child";
#      window_opacity = "off";
#      window_topmost = "on";
#      window_shadow = "float";
#      active_window_opacity = "1.0";
#      normal_window_opacity = "1.0";
#      split_ratio = "0.50";
#      auto_balance = "on";
#      mouse_modifier = "alt";
#      mouse_action1 = "move";
#      mouse_action2 = "resize";
#      layout = "bsp";
#      top_padding = 10;
#      bottom_padding = 10;
#      left_padding = 10;
#      right_padding = 10;
#      window_gap = 10;
#      external_bar = "main:26:0";
#    };
#
#    extraConfig = pkgs.lib.mkDefault ''
#      # rules
#      yabai -m rule --add app='System Preferences' manage=off
#      yabai -m rule --add app='Yubico Authenticator' manage=off
#      yabai -m rule --add app='YubiKey Manager' manage=off
#      yabai -m rule --add app='YubiKey Personalization Tool' manage=off
#      yabai -m rule --add app='Live' manage=off
#      yabai -m rule --add app='Xcode' manage=off
#      yabai -m rule --add app='Emacs' title='.*Minibuf.*' manage=off border=off
#    '';
#  };

#  launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "/tmp/yabai.log";
#  launchd.user.agents.yabai.serviceConfig.StandardOutPath = "/tmp/yabai.log";

#  services.spacebar.enable = true;
#  services.spacebar.package = pkgs.spacebar;
#  services.spacebar.config = {
#    debug_output = "on";
#    display = "main";
#    position = "top";
#    clock_format = "%R";
#    text_font = ''"Roboto Mono:Regular:12.0"'';
#    icon_font = ''"Font Awesome 5 Free:Solid:12.0"'';
#    background_color = "0xff222222";
#    foreground_color = "0xffd8dee9";
#    space_icon_color = "0xffffab91";
#    dnd_icon_color = "0xffd8dee9";
#    clock_icon_color = "0xffd8dee9";
#    power_icon_color = "0xffd8dee9";
#    battery_icon_color = "0xffd8dee9";
#    power_icon_strip = " ";
#    space_icon = "•";
#    space_icon_strip = "1 2 3 4 5 6 7 8 9 10";
#    spaces_for_all_displays = "on";
#    display_separator = "on";
#    display_separator_icon = "";
#    space_icon_color_secondary = "0xff78c4d4";
#    space_icon_color_tertiary = "0xfffff9b0";
#    clock_icon = "";
#    dnd_icon = "";
#    right_shell = "on";
#    right_shell_icon = "";
#    right_shell_icon_color = "0xffd8dee9";
#  };
#
#  launchd.user.agents.spacebar.serviceConfig.EnvironmentVariables.PATH = pkgs.lib.mkForce
#    (builtins.replaceStrings [ "$HOME" ] [ config.users.users.cmacrae.home ] config.environment.systemPath);
#  launchd.user.agents.spacebar.serviceConfig.StandardErrorPath = "/tmp/spacebar.err.log";
#  launchd.user.agents.spacebar.serviceConfig.StandardOutPath = "/tmp/spacebar.out.log";

  # launchd.user.agents.nginx = {
  #   command = "${pkgs.nginx}/bin/nginx -e /tmp/nginx/error.log -p /tmp -c ~/.nginx/config";
  #   path = [pkgs.nginx];
  #   serviceConfig = {
  #     KeepAlive = true;
  #   };
  # };

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;

  home-manager.users.steve = {

  # home.activation = {
  #     # This should be removed once
  #     # https://github.com/nix-community/home-manager/issues/1341 is closed.
  #     aliasApplications = inputs.home.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #       app_folder="$(echo ~/Applications)/Home Manager Apps"
  #       home_manager_app_folder="$genProfilePath/home-path/Applications"
  #       $DRY_RUN_CMD rm -rf "$app_folder"
  #       # NB: aliasing ".../home-path/Applications" to "~/Applications/Home Manager Apps" doesn't
  #       #     work (presumably because the individual apps are symlinked in that directory, not
  #       #     aliased). So this makes "Home Manager Apps" a normal directory and then aliases each
  #       #     application into there directly from its location in the nix store.
  #       $DRY_RUN_CMD mkdir "$app_folder"
  #       for app in $(find "$newGenPath/home-path/Applications" -type l -exec readlink -f {} \;)
  #       do
  #         $DRY_RUN_CMD osascript \
  #           -e "tell app \"Finder\"" \
  #           -e "make new alias file at POSIX file \"$app_folder\" to POSIX file \"$app\"" \
  #           -e "set name of result to \"$(basename $app)\"" \
  #           -e "end tell"
  #       done
  #     '';
  #   };

    home.stateVersion = "22.05";

    home.packages = with pkgs; [
      alacritty
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      autoconf
      #awscli2
      bat
      bc
      clang
      coreutils
      diff-so-fancy
      duf
      fd
      (ffmpeg-full.override {game-music-emu = null;})
      fx
      fzf
      git-lfs
      git-filter-repo
      gnumake
      gnupg
      gnused
      htop
      iftop
      influxdb
      ipcalc
      jq
      #kitty
      lorri
      ncurses6
      nix-prefetch-git
      nmap
      #nginx
      python3
      ripgrep
      rsync
      silver-searcher
      ssm-session-manager-plugin
      up
      websocat
      wget
      youtube-dl

      # Docker
      # docker

      # k8s
      # argocd
      # kind
      # kubectl
      # kubectx
      # kubeval
      # kube-prompt
      # kubernetes-helm
      # kustomize
    ];

    home.sessionVariables = {
      PAGER = "less -R";
    };

    programs.git = {
      enable = true;
      userName = fullName;
      userEmail = primaryEmail;
      extraConfig = {
        github = {
          user = "srstrong";
        };
        core = {
          pager = "diff-so-fancy | less --tabs=4 -RFX";
        };
        interactive = {
          diffFilter = "diff-so-fancy --patch";
        };
        color = {
          ui = true;
          diff-highlight = {
            oldNormal = "red bold";
            oldHighlight = "red bold 52";
            newNormal = "green bold";
            newHighlight = "green bold 22";
          };
          diff = {
            meta = "11";
            frag = "magenta bold";
            func = "146 bold";
            commit = "yellow bold";
            old = "red bold";
            new = "green bold";
            whitespace = "red reverse";
          };
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.file = ({
      ".config/kitty/kitty.conf".source = ../files/kitty.conf;
      ".alacritty.yml".source = ../files/alacritty.yml;
      ".ssh/config".source = ../files/ssh_config;
      ".nginx/config".source = ../files/nginx.config;
      ".nginx/m1.gables.com.crt".source = private.m1-gables-com-crt;
      ".nginx/m1.gables.com.key".source = private.m1-gables-com-key;
      ".config/nixpkgs/config.nix".text = ''
                                          { ... }:

        { allowUnsupportedSystem = true; }
      '';
      ".doom.d" = {
        source = ../files/doom;
        recursive = true;
        onChange = builtins.readFile ../files/doom/bin/reload;
      };
      "Library/Application\ Support/erlang_ls".source = ../files/erlang-ls-config.yaml;
    } //
    (if nix-env-config.os == "darwin" then
      {
      "Library/Application\ Support/erlang_ls".source = ../files/erlang-ls-config.yaml;
      }
     else
       {
         ".erlang_ls".source = ../files/erlang-ls-config.yaml;
       }
    ));


    ###########
    # Firefox #
    ###########
#    programs.firefox.enable = true;
#    # Handled by the Homebrew module
#    # This populates a dummy package to satsify the requirement
#    programs.firefox.package = pkgs.runCommand "firefox-0.0.0" { } "mkdir $out";
#    programs.firefox.extensions =
#      with pkgs.nur.repos.rycee.firefox-addons; [
#        ublock-origin
#        browserpass
#        vimium
#      ];
#
#    programs.firefox.profiles =
#      let
#        #userChrome = builtins.readFile ../conf.d/userChrome.css;
#        settings = {
#          "app.update.auto" = false;
#          "browser.startup.homepage" = "https://lobste.rs";
#          "browser.search.region" = "GB";
#          "browser.search.countryCode" = "GB";
#          "browser.search.isUS" = false;
#          "browser.ctrlTab.recentlyUsedOrder" = false;
#          "browser.newtabpage.enabled" = false;
#          "browser.bookmarks.showMobileBookmarks" = true;
#          "browser.uidensity" = 1;
#          "browser.urlbar.placeholderName" = "DuckDuckGo";
#          "browser.urlbar.update1" = true;
#          "distribution.searchplugins.defaultLocale" = "en-GB";
#          "general.useragent.locale" = "en-GB";
#          "identity.fxaccounts.account.device.name" = config.networking.hostName;
#          "privacy.trackingprotection.enabled" = true;
#          "privacy.trackingprotection.socialtracking.enabled" = true;
#          "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
#          "reader.color_scheme" = "sepia";
#          "services.sync.declinedEngines" = "addons,passwords,prefs";
#          "services.sync.engine.addons" = false;
#          "services.sync.engineStatusChanged.addons" = true;
#          "services.sync.engine.passwords" = false;
#          "services.sync.engine.prefs" = false;
#          "services.sync.engineStatusChanged.prefs" = true;
#          "signon.rememberSignons" = false;
#          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
#        };
#      in
#      {
#        home = {
#          inherit settings;
#          #inherit userChrome;
#          id = 0;
#        };
#
#        work = {
#          #inherit userChrome;
#          id = 1;
#          settings = settings // {
#            "browser.startup.homepage" = "about:blank";
#            "browser.urlbar.placeholderName" = "Google";
#
#        };
#      };

    #########
    # Emacs #
    #########
    programs.emacs.enable = true;
    programs.emacs.package =
      (
        pkgs.emacsWithPackagesFromUsePackage {
          alwaysEnsure = true;
          alwaysTangle = true;

          # Custom overlay derived from 'emacs' flake input
          package = pkgs.emacs;
          config = "";
	      }
      );

    programs.fzf.enable = true;
    programs.fzf.enableZshIntegration = true;

#    programs.alacritty = {
#      enable = true;
#      settings = {
#        window.padding.x = 24;
#        window.padding.y = 24;
#        window.decorations = "buttonless";
#        window.dynamic_title = true;
#        scrolling.history = 100000;
#        live_config_reload = true;
#        selection.save_to_clipboard = true;
#        mouse.hide_when_typing = true;
#        use_thin_strokes = true;
#
#        font = {
#          size = 12;
#          normal.family = "Roboto Mono";
#        };
#
#        colors = {
#          cursor.cursor = "#81a1c1";
#          primary.background = "#2e3440";
#          primary.foreground = "#d8dee9";
#
#          normal = {
#            black = "#3b4252";
#            red = "#bf616a";
#            green = "#a3be8c";
#            yellow = "#ebcb8b";
#            blue = "#81a1c1";
#            magenta = "#b48ead";
#            cyan = "#88c0d0";
#            white = "#e5e9f0";
#          };
#
#          bright = {
#            black = "#4c566a";
#            red = "#bf616a";
#            green = "#a3be8c";
#            yellow = "#ebcb8b";
#            blue = "#81a1c1";
#            magenta = "#b48ead";
#            cyan = "#8fbcbb";
#            white = "#eceff4";
#          };
#        };
#
#        key_bindings = [
#          { key = "V"; mods = "Command"; action = "Paste"; }
#          { key = "C"; mods = "Command"; action = "Copy"; }
#          { key = "Q"; mods = "Command"; action = "Quit"; }
#          { key = "Q"; mods = "Control"; chars = "\\x11"; }
#          { key = "F"; mods = "Alt"; chars = "\\x1bf"; }
#          { key = "B"; mods = "Alt"; chars = "\\x1bb"; }
#          { key = "D"; mods = "Alt"; chars = "\\x1bd"; }
#          { key = "Key3"; mods = "Alt"; chars = "#"; }
#          { key = "Slash"; mods = "Control"; chars = "\\x1f"; }
#          { key = "Period"; mods = "Alt"; chars = "\\e-\\e."; }
#          {
#            key = "N";
#            mods = "Command";
#            command = {
#              program = "open";
#              args = [ "-nb" "io.alacritty" ];
#            };
#          }
#        ];
#      };
#    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      sessionVariables = {
        RPROMPT = "";
        FZF_DEFAULT_COMMAND = "fd --type f";
      };

      shellAliases = {
        cat = "bat";
        diff = "diff -u | diff-so-fancy";
#        k = "kubectl";
#        kp = "kube-prompt";
#        kc = "kubectx";
#        kn = "kubens";
#        t = "cd $(mktemp -d)";
      };

      oh-my-zsh.enable = true;

      plugins = [
        {
          name = "autopair";
          file = "autopair.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "4039bf142ac6d264decc1eb7937a11b292e65e24";
            sha256 = "02pf87aiyglwwg7asm8mnbf9b2bcm82pyi1cj50yj74z4kwil6d1";
          };
        }
#        {
#          name = "fast-syntax-highlighting";
#          file = "fast-syntax-highlighting.plugin.zsh";
#          src = pkgs.fetchFromGitHub {
#            owner = "zdharma";
#            repo = "fast-syntax-highlighting";
#            rev = "v1.28";
#            sha256 = "106s7k9n7ssmgybh0kvdb8359f3rz60gfvxjxnxb4fg5gf1fs088";
#          };
#        }
        {
          name = "z";
          file = "zsh-z.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "agkozak";
            repo = "zsh-z";
            rev = "41439755cf06f35e8bee8dffe04f728384905077";
            sha256 = "1dzxbcif9q5m5zx3gvrhrfmkxspzf7b81k837gdb93c4aasgh6x6";
          };
        }
      ];

      initExtra = ''
          PROMPT=' %{$fg_bold[blue]%}$(get_pwd)%{$reset_color%} ''${prompt_suffix}'
          local prompt_suffix="%(?:%{$fg_bold[green]%}❯ :%{$fg_bold[red]%}❯%{$reset_color%} "

          function get_pwd(){
              git_root=$PWD
              while [[ $git_root != / && ! -e $git_root/.git ]]; do
                  git_root=$git_root:h
              done
              if [[ $git_root = / ]]; then
                  unset git_root
                  prompt_short_dir=%~
              else
                  parent=''${git_root%\/*}
                  prompt_short_dir=''${PWD#$parent/}
              fi
              echo $prompt_short_dir
                                      }

          vterm_printf(){
              if [ -n "$TMUX" ]; then
                  # Tell tmux to pass the escape sequences through
                  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
                  printf "\ePtmux;\e\e]%s\007\e\\" "$1"
              elif [ "''${TERM%%-*}" = "screen" ]; then
                  # GNU screen (screen, screen-256color, screen-256color-bce)
                  printf "\eP\e]%s\007\e\\" "$1"
              else
                  printf "\e]%s\e\\" "$1"
              fi
        }
      '';
    };

    programs.tmux =
      let
        kubeTmux = pkgs.fetchFromGitHub {
          owner = "jonmosco";
          repo = "kube-tmux";
          rev = "7f196eeda5f42b6061673825a66e845f78d2449c";
          sha256 = "1dvyb03q2g250m0bc8d2621xfnbl18ifvgmvf95nybbwyj2g09cm";
        };

        tmuxYank = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-yank";
          rev = "ce21dafd9a016ef3ed4ba3988112bcf33497fc83";
          sha256 = "04ldklkmc75azs6lzxfivl7qs34041d63fan6yindj936r4kqcsp";
        };


      in
      {
        enable = true;
        terminal = "xterm-256color";
        extraConfig = ''
          set -g history-limit 16384
          set -ga terminal-overrides ",xterm-256color:Tc"
          set -g default-terminal "xterm-256color"
         '';
      };
  };
}
