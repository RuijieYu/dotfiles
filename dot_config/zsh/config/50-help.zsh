# this may fail, don't care
unalias run-help &>/dev/null
# load the help function
autoload -Uz run-help

__help_capture() {
    ${(z)PAGER:-less -R}
}

# Run `$CMD --help | $PAGER`.  This is mostly useful for programs, especially
# the recent ones, that do not ship with any external documentations.  I can't
# think of a way to seamlessly integrate with `run-help` without duplicating its
# source code, so this is a standalone widget without delegation to `run-help`.
__extended_run_help() {
    # (A) to convert scalar to array
    # (z) to split words with shell quoting rules
    # (Q) to strip one layer of quotes
    local cmd="${(Q)${(Az)=BUFFER}[1]}"
    local subcmd="${(Q)${(Az)=BUFFER}[2]}"

    # must be nonempty command
    test -n "$cmd" || return 0

    # Ref: https://zsh.sourceforge.io/Doc/Release/Expansion.html
    # In case of quotation marks -- gets rid of one layer, without
    # substitution.

    # certain special cases
    case "$cmd" in
    git) # where $cmd needs capture, and $cmd $sub no capture
        if test -n "$subcmd"; then
            "$cmd" "$subcmd" --help
        else
            "$cmd" --help | __help_capture
        fi ;;
    rustup | cargo) # where both $cmd and $cmd $sub need capture
        if test -n "$subcmd"; then
            "$cmd" "$subcmd" --help
        else
            "$cmd" --help
        fi | __help_capture
        ;;
    *)
        # otherwise, run --help and pipe to pager
        "$cmd" --help | __help_capture
        ;;
    esac
}
zle -N __extended_run_help
bindkey '^[j' __extended_run_help
