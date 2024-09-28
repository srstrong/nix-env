set -e

nix build --extra-experimental-features nix-command --extra-experimental-features flakes --impure .\#darwinConfigurations.macbookM1.system
./result/sw/bin/darwin-rebuild switch --flake .#macbookM1
