#!/bin/bash

# Configurations. {{{1

# Make symlinks to dot files. {{{2
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

# Make ~/.config directory. {{{2
if [ ! -d ~/.config ]; then
    echo "dir: ~/.config"
    mkdir ~/.config
fi

# Make symlinks to dot directories. {{{2
for name in \
    alacritty \
    bat \
    emacs \
    git \
    newsboat \
    nvim \
    ; \
do
    if [ ! -L ~/.config/"$name" ]; then
        echo "symlink: ~/.config/$name"
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done

# Scripts. {{{1

# Make ~/bin directory. {{{2
if [ ! -d ~/bin ]; then
    echo "dir: ~/bin"
    mkdir ~/bin
fi

# Make symlinks to utility scripts. {{{2
for name in \
    tmux-pane-idx \
    ; \
do
    if [ ! -L ~/bin/"$name" ]; then
        echo "symlink: ~/bin/$name"
        ln -s -f ~/dotfiles/bin/"$name" ~/bin/"$name"
    fi
done

# Application-specific configurations. {{{1

# Alacritty {{{2
if [ ! -f ~/.config/alacritty/alacritty.local.yml ]; then
    echo "symlink: ~/.config/alacritty/alacritty.local.yml"
    if [[ "$(uname)" == "Darwin" ]]; then
        ln -s -f ~/.config/alacritty/alacritty.macos.yml ~/.config/alacritty/alacritty.local.yml
    else
        ln -s -f ~/.config/alacritty/alacritty.linux.yml ~/.config/alacritty/alacritty.local.yml
    fi
fi

# Neovim: paq-nvim {{{2
paq_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
if [ ! -d "$paq_dir" ]; then
    echo "clone: $paq_dir"
    git clone --depth=1 https://github.com/savq/paq-nvim.git "$paq_dir"
fi

# SKK {{{2
if [ ! -d ~/.config/skk ]; then
    echo "dir: ~/.config/skk"
    mkdir ~/.config/skk
fi

# SKK: download jisyo file. {{{2
if [ ! -f ~/.config/skk/jisyo.L ]; then
    echo "download: ~/config/.skk/jisyo.L"
    _compressed_jisyo="$(mktemp)"
    curl -fL -o "$_compressed_jisyo" https://skk-dev.github.io/dict/SKK-JISYO.L.unannotated.gz
    gunzip -cd "$_compressed_jisyo" > ~/.config/skk/jisyo.L
fi

# vim: foldmethod=marker
