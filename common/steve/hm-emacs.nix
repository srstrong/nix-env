# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "c456764cdce036f0340b2a5f138416cf39dcca6f";
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
