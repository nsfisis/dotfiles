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
    vim \
    ; \
do
    if [ ! -L ~/.config/"$name" ]; then
        echo "symlink: ~/.config/$name"
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done

if [ ! -f ~/dotfiles/.config/vim/autoload/plug.vim ]; then
    echo "download: ~/dotfiles/.config/vim/autoload/plug.vim"
    curl -fLo ~/dotfiles/.config/vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
