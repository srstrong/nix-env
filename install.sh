#!/bin/bash
set -e

if grep nix /etc/synthetic.conf >/dev/null 2>&1; then
   echo "Already have nix in /etc/synthetic.conf - aborting"
   exit 1
fi

if grep nix /etc/fstab >/dev/null 2>&1; then
   echo "Already have nix in /etc/fstab - aborting"
   exit 1
fi

if [[ -e /nix ]]; then
   echo "Already have /nix"
   exit 1
fi

echo Preconditions passed...

echo nix | sudo tee -a /etc/synthetic.conf > /dev/null
sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B
sudo diskutil apfs addVolume disk1 APFSX Nix -mountpoint /nix
sudo diskutil enableOwnership /nix
sudo chown -R $(id -n -u) /nix || true
echo 'LABEL=Nix /nix apfs rw' | sudo tee -a /etc/fstab > /dev/null
curl https://nixos.org/nix/install | sh
. /Users/$(id -n -u)/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
cp home.nix ~/.config/nixpkgs
home-manager switch

