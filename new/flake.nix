{
  description = "srstrong nix setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs = {
      url = "github:cmacrae/emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, emacs }: {
    darwinConfigurations.macbookM1 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        ./common/system-configuration.nix
        ./common/home-configuration.nix
        {
          nixpkgs.overlays = [
            emacs.overlay
          ];
        }
      ];

      inputs = { inherit darwin nixpkgs; };
    };
  };
}
