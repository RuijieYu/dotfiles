# if running under kitty TERM, use the kitty kitten alias for ssh
case "$TERM" in
    xterm-kitty) alias ssh='kitty +kitten ssh' ;;
esac
