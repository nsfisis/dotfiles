#!/bin/bash

# Remove old settings. {{{1

# Emacs {{{2

emacs_conf_dir="${XDG_CONFIG_HOME:-$HOME/.config}"/emacs
if [ -d "$emacs_conf_dir" ]; then
    echo "emacs: remove $emacs_conf_dir"
    rm -rf "$emacs_conf_dir"
fi

# Synchronize current settings. {{{1

# Neovim {{{2
if type nvim >/dev/null 2>&1; then
    packer_nvim_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/packer/opt/packer.nvim
    nvim_conf_dir="${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
    if [ -d "$packer_nvim_dir" -a -d "$nvim_conf_dir" ]; then
        echo "neovim: compile"
        nvim --headless -u "$nvim_conf_dir/init.mini.lua" -c 'autocmd User PackerCompileDone quitall' -c 'PackerCompile'
        echo "neovim: sync"
        nvim --headless -u "$nvim_conf_dir/init.mini.lua" -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    fi
fi

# Bat {{{2
if type bat >/dev/null 2>&1; then
    echo "bat: rebuild cache"
    bat cache --clear && bat cache --build
fi

# }}}
# }}}
# vim: foldmethod=marker
