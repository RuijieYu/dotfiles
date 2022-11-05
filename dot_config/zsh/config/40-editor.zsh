# configurations regarding editors
#
# Primary editor: emacs, preferably server;
# Secondary editor: vim family
# Fallback editor: nano
export EDITOR=nano VISUAL=nano

if found emacs; then
    EMACSCLIENT=emacsclient
    export ALTERNATE_EDITOR=/usr/bin/emacs

    # should not "no-wait", because things like git will wait
    export EDITOR="${EMACSCLIENT} -c -nw"
    export VISUAL="${EMACSCLIENT} -c"
else
    # check if nvim/nvim-qt, vim/gvim, or vi is available
    visual_list=(
        nvim-qt gvim # vim-like gui
        nvim vim     # vim-like tui
        vi)          # vi
    editor_list=(
        nvim vim     # vim-like tui
        nvim-qt gvim # vim-like gui
        vi)          # vi
    export VISUAL="$(first-found "${visual_list[@]}" "$VISUAL")"
    export EDITOR="$(first-found "${editor_list[@]}" "$EDITOR")"
    true
fi

# set an alias for quick editing
alias e='eval $VISUAL'

# $@ = env-name
emacs_load_env() {
    for name; do
        # ignore unset variables
        [[ -v $name ]] || continue
        local val="$(eval echo \$$name)"
        test -z "$val" ||
            emacsclient --alternate-editor=/bin/false \
                --eval "(setenv \"$name\" \"$val\")" >/dev/null
    done
}

emacs_useful_env=(
    # display server locations
    DISPLAY WAYLAND_DISPLAY
    # i3/sway related
    I3SOCK SWAYSOCK
    # firefox environment
    MOZ_ENABLE_WAYLAND
    # Python / pyenv
    PYENV_ROOT
)
alias emacs_load_useful_env=' emacs_load_env \
                              ${emacs_useful_env[@]}'
