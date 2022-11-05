# setting environment for shells running inside emacs

# $#=0, open *scratch* buffer
# $#=1, $1: file name to edit
edit_inside_emacs() {
    local file="$1"
    if test -n "$file"; then
        emacsclient -n "$file"
    else
        # don't need to look at the "#<buffer ...>" line
        emacsclient --eval '(switch-to-buffer "*scratch*")' \
            >/dev/null
    fi
}

# this assumes emacs is running as a server
case "$INSIDE_EMACS" in
# running directly as an emacs buffer
vterm | *,term:* | *,comint)
    export \
        EDITOR=emacsclient \
        VISUAL=emacsclient
    alias emacs=edit_inside_emacs
    ;;
# probably unrelated to emacs or started from term emulator
*,eshell | '') ;;
# for future expansion
*) echo "Unrecognized INSIDE_EMACS=$INSIDE_EMACS" >&2 ;;
esac
