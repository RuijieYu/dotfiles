found pyenv && {
    export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
    prepend_path PATH "$PYENV_ROOT/shims"

    eval "$(pyenv init --path zsh)"
    eval "$(pyenv init -)"

    found fzf && {
        _sel_ver() {
            fzf --tiebreak=index \
                --tac \
                --height "${FZF_TMUX_HEIGHT:-~40%}" "$@" |
                awk '{$1=$1};1'
        }

        pyver() {
            # ref: https://unix.stackexchange.com/a/205854
            local ver="$(pyenv versions | _sel_ver)"
            test -z "$ver" || pyenv shell "$ver"
        }

        pyinstall() {
            local ver
            for ver in $(pyenv install -l | _sel_ver -m); do
                pyenv install "$@" "$ver"
            done
        }
    }
}
