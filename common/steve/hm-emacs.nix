# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "054abca26f9cf416701c880792b564019d528566";
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import emacs-overlay)
      ];
    };
in

{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = (nixpkgs.emacsWithPackagesFromUsePackage {
             config = "";
             #package = nixpkgs.emacsGcc;
             package = nixpkgs.emacsUnstable;
             alwaysEnsure = true;
             });
  };

  home.file.".doom.d" = {
    source = ./files/doom;
    recursive = true;
    onChange = builtins.readFile ./files/doom/bin/reload;
  };
}
