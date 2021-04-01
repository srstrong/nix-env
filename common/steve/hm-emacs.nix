# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "360f24a1de8fcc3ea31c89d64b5ab6269037064a";
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
             package = nixpkgs.emacsGcc;
             alwaysEnsure = true;
             });
  };

  home.file.".doom.d" = {
    source = ./files/doom;
    recursive = true;
    onChange = builtins.readFile ./files/doom/bin/reload;
  };
}
