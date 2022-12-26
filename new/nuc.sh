set -e

nixos-rebuild build --flake .#nuc
sudo nixos-rebuild switch --flake .#nuc
