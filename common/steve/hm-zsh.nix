# vim: set sts=2 ts=2 sw=2 expandtab :

{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    history = {
      share = false;
    };
    shellAliases = {
      "ls" = "ls --color=tty";
    };
    sessionVariables = {};
    initExtra = ''

      # Make nix things available (for non NixOS
      # environments)
      if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]
      then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      # Update history incrementally
      INC_APPEND_HISTORY="true"

      DISABLE_AUTO_TITLE="true"

      # Colors please
      eval "$(${pkgs.coreutils}/bin/dircolors -b)"

      # Let Java know that we're using a non-reparenting WM
      export _JAVA_AWT_WM_NONREPARENTING=1

      # Force UTF-8
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8

      # Turn off autocomplete fo git
      compdef -d git

      alias emacs="emacs -nw"
      alias dhall-format="dhall format"

#      export LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"

      export ERL_AFLAGS="-kernel shell_history enabled"
      autoload -Uz compinit
      compinit
#      kitty + complete setup zsh | source /dev/stdin

    '';
    profileExtra = ''
    '';
    plugins = [];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    # NOTE: syntaxHighlighting isn't provided by home-manager
  };
}
