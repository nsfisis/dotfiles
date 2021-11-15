#!/bin/bash

log="$(mktemp)"
vim --startuptime "$log"
sort -nr -k2 "$log" | head -n 30 > ./vim-startup.log
