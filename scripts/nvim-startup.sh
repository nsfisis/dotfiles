#!/bin/bash

log="$(mktemp)"
nvim --startuptime "$log" +q
sort -nr -k2 "$log" > ./nvim-startup.log
