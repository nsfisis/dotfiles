#!/bin/bash

if [[ "$1" == '-s' ]]; then
    _filter='sort -nr -k2'
else
    _filter='cat'
fi

log="$(mktemp)"
nvim --startuptime "$log" +q
$_filter "$log" > ./nvim-startup.log
