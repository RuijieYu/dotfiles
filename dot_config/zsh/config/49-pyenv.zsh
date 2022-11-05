found pyenv && {
    export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
    prepend_path PATH "$PYENV_ROOT/shims"

    eval "$(pyenv init --path zsh)"
    eval "$(pyenv init -)"
}
