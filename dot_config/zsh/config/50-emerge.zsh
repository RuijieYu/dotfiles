# when emerge is found (gentoo and derivatives) and running as
# non-root user, *pretend* because the user cannot modify anything
# anyways.
found emerge || return
test "$USER" = root || return

# alias emerge to pretend
alias emerge='emerge --pretend --verbose'
