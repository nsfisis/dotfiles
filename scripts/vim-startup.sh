#!/bin/bash

if [[ "$1" == '-n' ]]; then
    vim=nvim
else
    vim=vim
fi

log="$(mktemp)"
$vim --startuptime "$log" +q
sort -nr -k2 "$log" | head -n 30 > ./$vim-startup.log
