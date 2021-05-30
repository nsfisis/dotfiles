#!/bin/sh

for filename in .gitconfig .vim .vimrc .zshrc
do
    rm -f ~/$filename
    ln -s ~/dotfiles/$filename ~/$filename
done

[ -d ~/.config ] || mkdir ~/.config
for dirname in alacritty git
do
    rm -f ~/.config/$dirname
    ln -s ~/dotfiles/.config/$dirname ~/.config/$dirname
done
