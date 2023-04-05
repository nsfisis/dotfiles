#!/bin/bash

# Remove old settings. {{{1

# Emacs {{{2

emacs_conf_dir="${XDG_CONFIG_HOME:-$HOME/.config}"/emacs
if [ -d "$emacs_conf_dir" ]; then
    echo "emacs: remove $emacs_conf_dir"
    rm -rf "$emacs_conf_dir"
fi

# Synchronize current settings. {{{1

# Bat {{{2
if type bat >/dev/null 2>&1; then
    echo "bat: rebuild cache"
    bat cache --clear && bat cache --build
fi

# }}}
# }}}
# vim: foldmethod=marker
