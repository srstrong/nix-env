
{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAbbrs = {
         # Git abbreviations
         "ga" = "git add";
         "gc" = "git commit";
         "gcam" = "git commit -am";
         "gcm" = "git commit -m";
         "gco" = "git checkout";
         "gcob" = "git checkout -b";
         "gcom" = "git checkout master";
         "gcod" = "git checkout develop";
         "gd" = "git diff";
         "gp" = "git push";
         "gdc" = "git diff --cached";
         "glg" = "git log --color --graph --pretty --oneline";
         "glgb" = "git log --all --graph --decorate --oneline --simplify-by-decoration";
         "gst" = "git status";
         "emacs" = "emacs -nw";
       };

       interactiveShellInit =
         ''
         '';
       promptInit =
         ''
            if test -n $HOME
              set -l NIX_LINK $HOME/.nix-profile

              if test ! -L $NIX_LINK
                echo "creating $NIX_LINK" >&2
                set -l _NIX_DEF_LINK /nix/var/nix/profiles/default
                /nix/store/cdybb3hbbxf6k84c165075y7vkv24vm2-coreutils-8.23/bin/ln -s $_NIX_DEF_LINK $NIX_LINK
              end

              set -x PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
              set -x MANPATH $NIX_LINK/share/man $MANPATH

              if test ! -e $HOME/.nix-channels
                echo "https://nixos.org/channels/nixpkgs-unstable nixpkgs" > $HOME/.nix-channels
              end

              set -x NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs:/Users/steve/.nix-defexpr/channels

              if test -e /etc/ssl/certs/ca-certificates.crt
                set -x SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
              else if test -e /etc/ssl/certs/ca-bundle.crt
                set -x SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
              else if test -e /etc/pki/tls/certs/ca-bundle.crt
                set -x SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
              else if test -e $NIX_LINK/etc/ssl/certs/ca-bundle.crt
                set -x SSL_CERT_FILE $NIX_LINK/etc/ssl/certs/ca-bundle.crt
              else if test -e $NIX_LINK/etc/ca-bundle.crt
                set -x SSL_CERT_FILE $NIX_LINK/etc/ca-bundle.crt
              end
            end
            # Emacs ansi-term support
            if test -n "$EMACS"
                set -x TERM eterm-color
                # Disable right prompt in emacs
                function fish_right_prompt; true; end
                #This function may be required for Emacs support.
                function fish_title; true; end
            end

            # Disable the vim-mode indicator [I] and [N].
            # Let the theme handle it instead.
            function fish_default_mode_prompt; true; end

            function reverse_history_search
              history | fzf --no-sort | read -l command
              if test $command
                commandline -rb $command
              end
            end

            function fish_user_key_bindings
              bind \cr reverse_history_search
            end

            function fish_title
              set defaulted_name $window_name localhost 
              echo $defaulted_name[1] #: (status current-command) (__fish_pwd)
            end

            # chips
            if [ -e ~/.config/chips/build.fish ] ; . ~/.config/chips/build.fish ; end
         '';
 };
}
