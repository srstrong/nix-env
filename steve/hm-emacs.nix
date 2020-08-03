# vim: set sts=2 ts=2 sw=2 expandtab :

{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs26-nox;
    extraPackages = (
      epkgs:
      [
        epkgs.melpaPackages.use-package

        # Search things
        epkgs.melpaPackages.ag
        epkgs.melpaPackages.helm-ag

        # Function complete
        epkgs.melpaPackages.smex

        # General things
        epkgs.melpaPackages.company
        epkgs.melpaPackages.editorconfig
        epkgs.melpaPackages.highlight-indent-guides
        epkgs.melpaPackages.magit
        epkgs.melpaPackages.neotree
        epkgs.melpaPackages.projectile
        epkgs.melpaPackages.rainbow-delimiters
        epkgs.melpaPackages.spaceline
        #epkgs.melpaPackages.textmate
        epkgs.melpaPackages.which-key

        # Flymake and flycheck
        epkgs.melpaPackages.flycheck
        epkgs.melpaPackages.flymake-cursor

        # LSP
        epkgs.melpaPackages.lsp-mode
        epkgs.melpaPackages.company-lsp
        epkgs.melpaPackages.lsp-ui
        epkgs.melpaPackages.helm-lsp
        epkgs.melpaPackages.lsp-ivy
        epkgs.melpaPackages.lsp-treemacs

        # Erlang
        epkgs.melpaPackages.auto-highlight-symbol
        epkgs.melpaPackages.eproject
        epkgs.melpaPackages.company-erlang
        epkgs.melpaPackages.erlang

        # ACE Jump
        epkgs.melpaPackages.ace-jump-mode
        epkgs.melpaPackages.ace-window

        # Rust
        epkgs.melpaPackages.cargo
        epkgs.melpaPackages.flycheck-rust
        epkgs.melpaPackages.racer
        epkgs.melpaPackages.rust-mode
        epkgs.melpaPackages.toml-mode

        # More language modes
        epkgs.melpaPackages.dhall-mode
        epkgs.melpaPackages.elm-mode
        epkgs.melpaPackages.js2-mode
        epkgs.melpaPackages.markdown-mode
        epkgs.melpaPackages.nix-mode
        epkgs.melpaPackages.psc-ide
        epkgs.melpaPackages.purescript-mode
        epkgs.melpaPackages.terraform-mode
        epkgs.melpaPackages.typescript-mode
        epkgs.melpaPackages.web-mode
        epkgs.melpaPackages.yaml-mode
        #epkgs.melpaPackages.fira-code-mode

        # Themes
        epkgs.melpaPackages.pastelmac-theme
        epkgs.melpaPackages.monokai-theme
        epkgs.melpaPackages.ir-black-theme
        epkgs.melpaPackages.solarized-theme
        epkgs.melpaPackages.underwater-theme
       ]
      );
  };

  home.file.".emacs.d/init.el".source = ./files/emacs-init.el;
  home.file.".emacs.d/site-lisp/flycheck-rebar3/flycheck-rebar3.el".source = ./files/flycheck-rebar3.el;
}
