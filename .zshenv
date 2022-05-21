# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Node
export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node_repl_history"
# SQLite
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
