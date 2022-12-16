#!/bin/bash

# Neovim {{{1
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

# Bat {{{1
if type bat >/dev/null 2>&1; then
    echo "bat: rebuild cache"
    bat cache --clear && bat cache --build
fi

# }}}
# vim: foldmethod=marker
