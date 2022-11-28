{
  description = "srstrong nix setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations.macbookM1 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./common/system-configuration.nix ];
      inputs = { inherit darwin nixpkgs; };
    };
  };
}
