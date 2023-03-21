set -e

nix --extra-experimental-features flakes --extra-experimental-features nix-command build --impure .\#darwinConfigurations.macbookM1.system
./result/sw/bin/darwin-rebuild switch --flake .#macbookM1
