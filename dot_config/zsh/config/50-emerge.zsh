# alias emerge to pretend
{ type emerge &>/dev/null &&
      test "$USER" = root
} || alias emerge='emerge --pretend --verbose'
