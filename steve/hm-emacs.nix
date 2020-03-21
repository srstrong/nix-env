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
        epkgs.melpaPackages.textmate

        # Flymake and flycheck - TODO - both still needed?
        epkgs.melpaPackages.flycheck

        # EDTS Requirements
        epkgs.melpaPackages.auto-complete
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

        # Themes
        epkgs.melpaPackages.ir-black-theme
        epkgs.melpaPackages.monokai-theme
        epkgs.melpaPackages.pastelmac-theme
        epkgs.melpaPackages.solarized-theme
        epkgs.melpaPackages.underwater-theme

       ]
      );
  };

  home.file.".emacs.d/init.el".source = ./files/emacs-init.el;
}
