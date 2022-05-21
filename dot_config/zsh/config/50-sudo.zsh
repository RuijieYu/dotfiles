alias S='sudo ' # allow alias substitution for next part

# prepend sudo by pressing alt-s (just like fish does)
__zsh_alt_s_prepend_sudo() {
    # if current line starts with sudo, then toggle
    if [[ $BUFFER == sudo\ * ]]; then
        BUFFER="${BUFFER#sudo }" # maybe cursor left of "sudo"
    elif [[ $BUFFER == S\ * ]]; then
        BUFFER="${BUFFER#S }" # aliased sudo
    else
        LBUFFER="S $LBUFFER" # prepend left of cursor, use alias
    fi
}

zle -N __zsh_alt_s_prepend_sudo
bindkey '^[s' __zsh_alt_s_prepend_sudo
