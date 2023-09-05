#!/bin/sh

if [ $# != 1 ]; then
    echo "Usage: $0 <host>" >&2
    echo "Availabel hosts:" >&2
    grep '= mkHomeConfiguration' flake.nix | cut -d '=' -f 1 | sed -e 's/^ */ * /' >&2
    exit 1
fi

(
    source .zshenv
    for dir in \
        "$XDG_CONFIG_HOME" \
        "$XDG_CACHE_HOME" \
        "$XDG_DATA_HOME" \
        "$XDG_STATE_HOME" \
        ; \
    do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
        fi
    done
)

if [ ! -d .bootstrap ]; then
    mkdir .bootstrap
fi
if [ ! -f .bootstrap/nix-install ]; then
    curl -o .bootstrap/nix-install -L https://nixos.org/nix/install
fi
if [ ! -d /nix ]; then
    sh .bootstrap/nix-install --daemon
    hash -r
fi
if ! grep -q "nix-command flakes" /etc/nix/nix.conf; then
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf > /dev/null
fi
if [ ! -d "$HOME/.local/state/nix/profiles" ]; then
    mkdir -p "$HOME/.local/state/nix/profiles"
fi
if ! type home-manager > /dev/null 2>&1; then
    nix run "nixpkgs#home-manager" -- switch --flake ".#$1"
fi
