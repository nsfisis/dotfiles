#!/bin/bash

log="$(mktemp)"
nvim --startuptime "$log" +q
sort -nr -k2 "$log" | head -n 30 > ./nvim-startup.log
