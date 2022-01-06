#!/bin/sh
get_path() {
    if type brew &>/dev/null ; then
        # homebrew (macos); requires llvm
        brew list -v llvm |
            grep llvm-mode.el\$ |
            head -n1 |
            xargs dirname
    elif type pacman &>/dev/null; then
        # pacman (arch); requires emacs-llvm-mode
        pacman -Ql emacs-llvm-mode |
            grep 'llvm-mode.el' |
            cut '-d ' -f2 |
            xargs dirname
    fi
} 2>/dev/null

llvm_mode_path="$(get_path)"
test -z "$llvm_mode_path" ||
    ln -vsfT \
       "$llvm_mode_path" \
       ~/.emacs.d/llvm-mode
