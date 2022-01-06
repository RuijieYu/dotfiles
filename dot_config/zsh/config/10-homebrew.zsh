# always put (potential) homebrew bin path on macos
test "$(uname -s)" = Darwin && case "$(uname -m)" in
    arm64) _prepend_path /opt/homebrew/{,s}bin ;;
    x86_64) _prepend_path /usr/local/{,s}bin ;;
    *) ;;
esac

# homebrew helper functions
__brew_prefix() {
    type brew &>/dev/null || return 1
    : "${_BREW_PREFIX:="$(brew --prefix)"}"
}
