{ pkgs, inputs, ... }:
let
  foo = "bar";
in
{
  home.stateVersion = "23.05";

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
      kitty
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
    ];

  programs.emacs.enable = true;
  programs.emacs.package = 
    (
      pkgs.emacsWithPackagesFromUsePackage {
        alwaysEnsure = true;
        alwaysTangle = true;

        # Custom overlay derived from 'emacs' flake input
#        package = pkgs.emacs;
        config = "";
            }
    );
}
