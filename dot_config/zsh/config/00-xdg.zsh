# setting up xdg directories
test -n "$HOME" || {
    echo '$HOME missing, skipping XDG setup'
    return
}

: "${XDG_CONFIG_HOME:="$HOME/.config"}"
: "${XDG_CACHE_HOME:="$HOME/.cache"}"
: "${XDG_DATA_HOME:="$HOME/.local/share"}"
: "${XDG_STATE_HOME:="$HOME/.local/state"}"

export XDG_CONFIG_HOME \
       XDG_CACHE_HOME \
       XDG_DATA_HOME \
       XDG_STATE_HOME
