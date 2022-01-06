# this may fail, don't care
unalias run-help &>/dev/null
# load the help function
autoload -Uz run-help

__zsh_alt_j_command_help() {
    # use LESS= to negate the effect of -XR
    _first() {
	echo "$1"
    }
    local -r exe="$(_first $BUFFER)"
    # echo "exe=$exe"
    
    type "$exe" &>/dev/null || return 0
    "$1" --help | LESS= less
    return 0
}

zle -N __zsh_alt_j_command_help
bindkey '^[j' __zsh_alt_j_command_help
