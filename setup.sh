#!/bin/sh

for filename in .gitconfig .gitignore_global .vim .vimrc .zshrc
do
    # Remove existing symbolic link.
    rm -rf ~/$filename
    # Create symbolic link.
    ln -s ~/dotfiles/$filename ~/$filename
done
