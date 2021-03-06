#!/bin/bash

for name in .gitconfig .tmux.conf .vim .vimrc .zshrc; do
    if [ ! -L ~/$name ]; then
        ln -s -f ~/dotfiles/$name ~/$name
    fi
done

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

for name in alacritty bat git; do
    if [ ! -L ~/.config/$name ]; then
        ln -s -f ~/dotfiles/.config/$name ~/.config/$name
    fi
done
