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

# Ensure there's a /nix mountpoint
echo nix | sudo tee -a /etc/synthetic.conf > /dev/null

# Process the above change to synthentic.conf
sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B

# Create an APFS volume for nix
sudo diskutil apfs addVolume disk1 APFSX Nix -mountpoint /nix
sudo diskutil enableOwnership /nix
sudo chown -R $(id -n -u) /nix || true

# Ensure it is loaded on reboots
echo 'LABEL=Nix /nix apfs rw' | sudo tee -a /etc/fstab > /dev/null

# Kick off the standard nix installation process
curl https://nixos.org/nix/install | sh

# Make nix available to the current shell
. /Users/$(id -n -u)/.nix-profile/etc/profile.d/nix.sh

# Install home-manager
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install

cd ~/.config/nixpkgs
ln -s "$(realpath "$(dirname "${BASH_SOURCE[0]}")/home.nix")" home.nix

# Get home-manager to apply the configuration
home-manager switch
