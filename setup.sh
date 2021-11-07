#!/bin/bash

echo "setup.sh"

for name in .gitconfig .tmux.conf .vim .vimrc .zshrc; do
    if [ ! -L ~/"$name" ]; then
        echo "* ln -s: ~/$name"
        ln -s -f ~/dotfiles/"$name" ~/"$name"
    fi
done

if [ ! -d ~/.config ]; then
    echo "* mkdir: ~/.config"
    mkdir ~/.config
fi

for name in alacritty bat git; do
    if [ ! -L ~/.config/"$name" ]; then
        echo "* ln -s: ~/.config/$name"
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done

echo "done"
