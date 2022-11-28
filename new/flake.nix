{
  description = "srstrong nix setup";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, emacs, emacs-overlay }@inputs: {
    darwinConfigurations.macbookM1 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        {
          nixpkgs.overlays = with inputs; [
            # nur.overlay
#            emacs.overlay
            emacs-overlay.overlay
          ];
        }
        ./common/system-configuration.nix
	./os/macos.nix
        home-manager.darwinModules.home-manager
        {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.steve = import ./common/home-configuration.nix;
        }

      ];

      inputs = { inherit darwin nixpkgs; };
    };
  };
}
