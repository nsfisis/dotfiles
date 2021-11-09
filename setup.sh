#!/bin/bash

for name in \
    .emacs.d \
    .gitconfig \
    .tmux.conf \
    .vim \
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
    git \
    ; \
do
    if [ ! -L ~/.config/"$name" ]; then
        echo "symlink: ~/.config/$name"
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done
