#!/bin/sh

if [ ! -d .bootstrap ]; then
    mkdir .bootstrap
fi
if [ ! -f .bootstrap/nix-install ]; then
    curl -o .bootstrap/nix-install -L https://nixos.org/nix/install
fi
if [ ! -d /nix ]; then
    sh .bootstrap/nix-install --daemon
fi
if grep -q "nix-command flakes" /etc/nix/nix.conf; then
    :
else
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf > /dev/null
fi
if [ ! -d "$HOME/.local/state/nix/profiles" ]; then
    mkdir -p "$HOME/.local/state/nix/profiles"
fi
if type home-manager > /dev/null 2>&1; then
    :
else
    nix run "nixpkgs#home-manager" -- switch --flake ".#ken"
fi
