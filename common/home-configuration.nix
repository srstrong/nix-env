{ pkgs, inputs, private, nix-env-config, ... }:
let
  foo = "bar";
in
{
  imports =
    (if nix-env-config.os == "darwin" then
      [ ./apps.nix
      ]
     else
       [
       ]
    );

  home.stateVersion = "23.05";

  disabledModules = [ "targets/darwin/linkapps.nix" ];

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
    (ffmpeg-full.override {withGme = false;})
    fx
    fzf
    git-lfs
    git-filter-repo
    gnumake
    gnupg
    gnused
    htop
    helix
    iftop
    influxdb
    ipcalc
    jq
    kitty
    lorri
    mediainfo
    ncurses6
    nix-prefetch-git
    nmap
    nodejs
    nginx
    python3
    ripgrep
    rsync
    silver-searcher
    ssm-session-manager-plugin
    up
    websocat
    wget
    yt-dlp
    zellij
  ];

  home.sessionVariables = {
    PAGER = "less -R";
    LSP_USE_PLISTS = "true";
  };

  programs.git = {
    enable = true;
    userName = private.user-info.fullName;
    userEmail = private.user-info.primaryEmail;
    extraConfig = {
      github = {
        user = "srstrong";
      };
      core = {
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      diff = {
        algorithm = "histogram";
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

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };

  programs.bash = {
    enable = true;
    initExtra = ''
  # eval "$(direnv hook bash)"
  '';
  };

  programs.emacs.enable = true;
  programs.emacs.package = 
    (
      pkgs.emacsWithPackagesFromUsePackage {
        alwaysEnsure = true;
        alwaysTangle = true;

        # Custom overlay derived from 'emacs' flake input
  # package = pkgs.emacs;
        config = "";
            }
    );

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    # autosuggestions.enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    sessionVariables = {
      RPROMPT = "";
      FZF_DEFAULT_COMMAND = "fd --type f";
    };

    shellAliases = {
      cat = "bat";
      diff = "f() { if (($# == 0)); then diff -u | diff-so-fancy; else diff -u $1 $2 | diff-so-fancy; fi}; f";
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

  # eval "$(direnv hook zsh)"
  export NIXPKGS_ALLOW_INSECURE=1
  export NIXPKGS_ALLOW_UNFREE=1
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
        set -sg escape-time 0
        bind-key Up    select-pane -U
        bind-key Down  select-pane -D
        bind-key Left  select-pane -L
        bind-key Right select-pane -R
       '';
    };

  home.file = ({
    ".config/kitty/kitty.conf".source = ../files/kitty.conf;
    ".alacritty.toml".source = ../files/alacritty.toml;
    ".ssh/config".source = ../files/ssh_config;
    ".nginx/config".source = ../files/nginx.config;
    ".config/helix/config.toml".source = ../files/helix/config.toml;
    ".config/helix/languages.toml".source = ../files/helix/languages.toml;
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

}
