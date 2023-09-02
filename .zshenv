# XDG Base Directories
# See: https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# XDG Base Directories: Node.js
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node_repl_history"
# XDG Base Directories: SQLite
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"


# Locale
export LANG=en_US.UTF-8
export LC_ALL=C

# Locale: Less
export LESSCHARSET=utf-8


# Path
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"


# Nix
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
