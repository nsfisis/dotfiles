#!/bin/sh

for name in .gitconfig .vim .vimrc .zshrc
do
    ln -s -f ~/dotfiles/$name ~/$name
done

[ -d ~/.config ] || mkdir ~/.config
for name in alacritty git starship.toml
do
    ln -s -f ~/dotfiles/.config/$name ~/.config/$name
done
