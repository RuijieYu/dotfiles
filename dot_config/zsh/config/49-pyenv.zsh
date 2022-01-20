export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"

eval "$(pyenv init --path zsh)"
eval "$(pyenv init -)"
