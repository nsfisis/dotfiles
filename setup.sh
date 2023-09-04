#!/bin/bash

# Requirements. {{{1

ok=1
for exe in \
    curl \
    git \
    go \
    gunzip \
    ; \
do
    if which "$exe" >/dev/null; then
        :
    else
        echo "error: $exe is missing" >&2
        ok=0
    fi
done
if [[ $ok = 0 ]]; then
    exit 1
fi

# Configurations. {{{1

# Make symlinks to dot files. {{{2
for name in \
    .vimrc \
    .zshenv \
    .zshrc \
    ; \
do
    if [ ! -L ~/"$name" ]; then
        echo "symlink: ~/$name"
        ln -s -f ~/dotfiles/"$name" ~/"$name"
    fi
done

# Make symlinks to dot directories. {{{2
for name in \
    alacritty \
    git \
    nvim \
    ; \
do
    if [ ! -L ~/.config/"$name" ]; then
        echo "symlink: ~/.config/$name"
        ln -s -f ~/dotfiles/.config/"$name" ~/.config/"$name"
    fi
done

# Tools. {{{1

# Golang: {{{2
for name in \
    gitalias/git-extract-issue \
    gitalias/git-sw \
    ; \
do
    src_file="src/$name.go"
    bin_file="bin/$name"
    if [[ "$bin_file" -ot "$src_file" ]]; then
        echo "build: $bin_file"
        go build -o "$bin_file" "$src_file"
    fi
done

# Scripts. {{{1

# Make ~/bin directory. {{{2
if [ ! -d ~/bin ]; then
    echo "dir: ~/bin"
    mkdir ~/bin
fi
if [ ! -d ~/bin/gitalias ]; then
    echo "dir: ~/bin/gitalias"
    mkdir ~/bin/gitalias
fi

# Make symlinks to utility scripts. {{{2
for name in \
    tmux-pane-idx \
    gitalias/git-extract-issue \
    gitalias/git-sw \
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

# Zsh {{{2
if [ ! -d "$XDG_STATE_HOME/zsh" ]; then
    echo "dir: $XDG_STATE_HOME/zsh"
    mkdir -p "$XDG_STATE_HOME/zsh"
fi

# }}}
# }}}
# vim: foldmethod=marker
