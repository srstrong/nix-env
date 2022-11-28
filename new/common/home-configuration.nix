{ pkgs, ... }:
let
  foo = "bar";
in
  nixpkgs.overlays = [
    emacs.overlay
  ];

  home-manager.users.steve = {
    programs.emacs.enable = true;
    programs.emacs.package =
      (
        pkgs.emacsWithPackagesFromUsePackage {
          alwaysEnsure = true;
          alwaysTangle = true;

          # Custom overlay derived from 'emacs' flake input
          package = pkgs.emacs;
          config = "";
              }
      );
  };
}
