# set up environment
type thefuck &>/dev/null || return 0

eval $(thefuck --alias)

# set up keybinding
function __zsh_alt_f_thefuck() {
    echo
    fuck
}

zle -N __zsh_alt_f_thefuck
bindkey '^[f' __zsh_alt_f_thefuck

