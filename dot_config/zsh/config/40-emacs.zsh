# configurations regarding emacs

EMACSCLIENT==emacsclient
export ALTERNATE_EDITOR=/usr/bin/emacs

# I have emacs server running
# alias emacs="${EMACSCLIENT} -c"

# should not "no-wait", because things like git will wait
export EDITOR="${EMACSCLIENT} -c -nw"
export VISUAL="${EMACSCLIENT} -c"
