# fix the keybinding issue
## key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char     # delete key
bindkey "\e[2~" quoted-insert   # insert key
bindkey "\e[3C" forward-word    # alt-arrow #1
bindkey '^[[1;3C' forward-word  # alt-arrow #2
bindkey "\e[5C" forward-word    # ctrl-arrow #1
bindkey '^[[1;5C' forward-word  # ctrl-arrow #2
bindkey "\eOc" emacs-forward-word
bindkey "\e[3D" backward-word   # alt-arrow #1
bindkey '^[[1;3D' backward-word # alt-arrow #2
bindkey "\e[5D" backward-word   # ctrl-arrow #1
bindkey '^[[1;5D' backward-word # ctrl-arrow #2
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "^H" backward-delete-word

## for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
## for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
## for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
## completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
