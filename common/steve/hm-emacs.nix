# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url =
        "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "29138420e18e2480f674663476663cffc6548fb4";
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
             config = ./files/emacs.el;
             package = nixpkgs.emacsGit-nox; 
             alwaysEnsure = true;
             });
  };

  home.file.".emacs.d/init.el".source = ./files/emacs.el;
  home.file.".emacs.d/site-lisp/flycheck-rebar3/flycheck-rebar3.el".source = ./files/flycheck-rebar3.el;
}
