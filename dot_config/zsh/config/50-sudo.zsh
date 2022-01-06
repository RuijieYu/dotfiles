# prepend sudo by pressing alt-s (just like fish does)
function __zsh_alt_s_prepend_sudo() {
    # if current line starts with sudo, then toggle? do nothing?
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}

zle -N __zsh_alt_s_prepend_sudo
bindkey '^[s' __zsh_alt_s_prepend_sudo

