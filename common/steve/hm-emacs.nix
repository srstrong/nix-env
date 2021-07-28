# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      #rev = "b539c9174b79abaa2c24bd773c855b170cfa6951";
      rev = "0fce209cb26c7f56090406058065081a3cddc76a";
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import emacs-overlay)
      ];
    };

  foo = nixpkgs.emacsGit.override { nativeComp = true; };
in

{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = (nixpkgs.emacsWithPackagesFromUsePackage {
             config = "";
             package = foo;
             #package = nixpkgs.emacsGcc;
             alwaysEnsure = true;
             });
  };

  home.file.".doom.d" = {
    source = ./files/doom;
    recursive = true;
    onChange = builtins.readFile ./files/doom/bin/reload;
  };
}
