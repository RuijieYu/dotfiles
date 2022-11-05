# rsync aliases for mv and cp
found rsync || return 0

# ref: https://wiki.archlinux.org/title/Rsync
alias rsync-cp='rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1'
alias rsync-mv='rsync-cp --remove-source-files'

# NOTE: `rsync -r src-dir dest-dir` would create dest-dir/src-dir,
# whereas `rsync -r src-dir/ dest-dir` or `rsync -r
# src-dir/. dest-dir` would copy children of src-dir into under
# dest-dir.
