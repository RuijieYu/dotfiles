#!/bin/sh

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

mkdir -p ~/.emacs.d && {
    clang_format_path="$(get_path)"
    test -z "$clang_format_path" ||
        ln -vsfT \
           "$clang_format_path" \
           ~/.emacs.d/clang-format
}
