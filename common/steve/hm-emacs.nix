# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "0fce209cb26c7f56090406058065081a3cddc76a";
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import emacs-overlay)
      ];
    };

  emacsNative = nixpkgs.emacsGit.override { nativeComp = true; };
in

{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = (nixpkgs.emacsWithPackagesFromUsePackage {
             config = "";
             package = emacsNative;
             alwaysEnsure = true;
             });
  };

  home.file.".doom.d" = {
    source = ./files/doom;
    recursive = true;
    onChange = builtins.readFile ./files/doom/bin/reload;
  };
}
