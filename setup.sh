#!/bin/bash

for name in \
    .tmux.conf \
    .vimrc \
    .zshrc \
    ; \
do
    if [ ! -L ~/"$name" ]; then
        echo "symlink: ~/$name"
        ln -s -f ~/dotfiles/"$name" ~/"$name"
    fi
done

if [ ! -d ~/.config ]; then
    echo "dir: ~/.config"
    mkdir ~/.config
fi

for name in \
    alacritty \
    bat \
    emacs \
    git \
    nvim \
    ; \
do
    if [ ! -L ~/.config/"$name" ]; then
        echo "symlink: ~/.config/$name"
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done

echo "symlink: ~/.config/alacritty/alacritty.local.yml"
if [[ "$(uname)" == "Darwin" ]]; then
    ln -s -f ~/.config/alacritty/alacritty.macos.yml ~/.config/alacritty/alacritty.local.yml
else
    ln -s -f ~/.config/alacritty/alacritty.linux.yml ~/.config/alacritty/alacritty.local.yml
fi

paq_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
if [ ! -d "$paq_dir" ]; then
    echo "clone: $paq_dir"
    git clone --depth=1 https://github.com/savq/paq-nvim.git "$paq_dir"
fi

if [ ! -d ~/.config/skk ]; then
    echo "dir: ~/.config/skk"
    mkdir ~/.config/skk
fi

if [ ! -f ~/.config/skk/jisyo.L ]; then
    echo "download: ~/config/.skk/jisyo.L"
    _compressed_jisyo="$(mktemp)"
    curl -fL -o "$_compressed_jisyo" https://skk-dev.github.io/dict/SKK-JISYO.L.unannotated.gz
    gunzip -cd "$_compressed_jisyo" > ~/.config/skk/jisyo.L
fi
