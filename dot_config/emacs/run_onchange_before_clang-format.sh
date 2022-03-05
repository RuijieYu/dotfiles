#!/bin/sh
EMACS_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs"

get_path() {
    if type brew &>/dev/null; then
        # homebrew (macos); requires either llvm or clang-format
        { brew list -v llvm
          brew list -v clang-format
        } | grep clang-format.el\$ |
            head -n1 |
            xargs dirname
    elif type pacman &>/dev/null; then
        # pacman (arch)
        pacman -Ql clang |
            grep -P clang-format.el\$ |
            cut '-d ' -f2 |
            xargs dirname
    fi
} 2>/dev/null

mkdir -p "$EMACS_CONFIG_DIR/" && {
    clang_format_path="$(get_path)"
    test -z "$clang_format_path" ||
        ln -vsfT \
           "$clang_format_path" \
           "$EMACS_CONFIG_DIR/"clang-format
}
