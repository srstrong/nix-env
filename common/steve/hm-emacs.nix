# vim: set sts=2 ts=2 sw=2 expandtab :
let
  emacs-overlay =
    builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "6f1b47652747b10b6e7e42377baf2bafb95cc854";
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
