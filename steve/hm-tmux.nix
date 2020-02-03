# vim: set sts=2 ts=2 sw=2 expandtab :

{ pkgs, lib, ... }:

let
  tmuxPlugins = with pkgs.tmuxPlugins; [
    resurrect
    sessionist
  ];
in
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g history-limit 16384
      set -g mouse on

      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

      bind-key -n DoubleClick1Pane \
                  select-pane \; \
                  copy-mode -M \; \
                  send-keys -X select-word \; \
                  run-shell "sleep .5s" \; \
                  send-keys -X copy-pipe-and-cancel "pbcopy"

      bind-key -T copy-mode DoubleClick1Pane \
                  select-pane \; \
                  send-keys -X select-word \; \
                  run-shell "sleep .5s" \; \
                  send-keys -X copy-pipe "pbcopy"

      # bind-key -n TripleClick1Pane \
      #             select-pane \; \
      #             copy-mode -M \; \
      #             send-keys -X select-line \; \
      #             run-shell "sleep .5s" \; \
      #             send-keys -X copy-pipe-and-cancel "pbcopy"

      # bind-key -T copy-mode TripleClick1Pane \
      #             select-pane \; \
      #             send-keys -X select-line \; \
      #             run-shell "sleep .5s" \; \
      #             send-keys -X copy-pipe "pbcopy"


      # Enable true-color for terminal type under which tmux runs
      set -ga terminal-overrides ",xterm-256color:Tc"

      # The terminal type to surface inside of tmux
      set -g default-terminal "xterm-256color"

      ${lib.concatStrings (map (x: "run-shell ${x.rtp}\n") tmuxPlugins)}
    '';

    # Don't use tmux-sensible for now because it tries
    # using reattach-to-user-namespace which causes a
    # warning in every pane on Catalina
    sensibleOnTop = false;

    # Assumes the presence of a /run directory, which we don't have on
    # macOS
    secureSocket = false;
  };
}
