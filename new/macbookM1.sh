set -e

nix build --impure .\#darwinConfigurations.macbookM1.system
./result/sw/bin/darwin-rebuild switch --flake .#macbookM1
