#!/bin/bash

if type vim-startuptime >/dev/null 2>&1; then
    vim-startuptime -vimpath nvim > ./nvim-startup.log
else
    log="$(mktemp)"
    nvim --startuptime "$log" +q
    sort -nr -k2 "$log" > ./nvim-startup.log
fi
