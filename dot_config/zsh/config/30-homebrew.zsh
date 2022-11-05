# This variable holds the homebrew prefix if available.
BREW_PREFIX=

# Assign homebrew prefix depending on environment
case "$(uname -s)!$(uname -m)" in
Darwin!arm64) BREW_PREFIX=/opt/homebrew ;;
Darwin!x86_64) BREW_PREFIX=/usr/local ;;
esac

# early exit if "brew" executable is not found; only check brew bins
PATH="$BREW_PREFIX/sbin:$BREW_PREFIX/bin" \
    found brew || return

# Add bin and sbin to path if available
for bin in "$BREW_PREFIX/"{,s}bin; do
    prepend_path PATH "$bin"
done

# add bin for gnu coreutils if available
test -z "$BREW_PREFIX" ||
    prepend_path PATH "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
