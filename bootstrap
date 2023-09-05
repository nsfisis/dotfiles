#!/bin/sh

if [ $# != 1 ]; then
    echo "Usage: $0 <host>" >&2
    echo "Availabel hosts:" >&2
    grep '= mkHomeConfiguration' flake.nix | cut -d '=' -f 1 | sed -e 's/^ */ * /' >&2
    exit 1
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

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

# These dotfiles are not managed by home-manager.
for name in \
    .vimrc \
    .zshenv \
    .zshrc \
    ; \
do
    if [ ! -L ~/"$name" ]; then
        ln -s -f ~/dotfiles/"$name" ~/"$name"
    fi
done
for name in \
    alacritty \
    git \
    nvim \
    ; \
do
    if [ ! -L ~/.config/"$name" ]; then
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done

# Go
for name in \
    gitalias/git-extract-issue \
    gitalias/git-sw \
    ; \
do
    src_file="src/$name.go"
    bin_file="bin/$name"
    if [ "$bin_file" -ot "$src_file" ]; then
        go build -o "$bin_file" "$src_file"
    fi
done
if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi
if [ ! -d ~/bin/gitalias ]; then
    mkdir ~/bin/gitalias
fi
for name in \
    tmux-pane-idx \
    gitalias/git-extract-issue \
    gitalias/git-sw \
    ; \
do
    if [ ! -L ~/bin/"$name" ]; then
        ln -s -f ~/dotfiles/bin/"$name" ~/bin/"$name"
    fi
done
if [ ! -f ~/.config/alacritty/alacritty.local.yml ]; then
    if [ "$(uname)" = "Darwin" ]; then
        ln -s -f ~/.config/alacritty/alacritty.macos.yml ~/.config/alacritty/alacritty.local.yml
    else
        ln -s -f ~/.config/alacritty/alacritty.linux.yml ~/.config/alacritty/alacritty.local.yml
    fi
fi
if [ ! -d ~/.config/skk ]; then
    mkdir ~/.config/skk
fi
if [ ! -f ~/.config/skk/jisyo.L ]; then
    _compressed_jisyo="$(mktemp)"
    curl -fL -o "$_compressed_jisyo" https://skk-dev.github.io/dict/SKK-JISYO.L.unannotated.gz
    gunzip -cd "$_compressed_jisyo" > ~/.config/skk/jisyo.L
fi
if [ ! -d "$XDG_STATE_HOME/zsh" ]; then
    mkdir -p "$XDG_STATE_HOME/zsh"
fi
