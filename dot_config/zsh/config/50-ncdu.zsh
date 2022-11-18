# does nothing when both ncdu and ncdu2 not found
found ncdu && ncdu=ncdu
found ncdu2 && ncdu=ncdu2
test -z "$ncdu" && return

ncdu_excludes=(
    .snapshots # my snapshot directories (managed by snapper)
    /mnt/btrfs # my btrfs maintenance mount directory
)

ncdu_excl_flags=(
    # according to ncdu, this flag only available for linux
    $(test Linux != "$(uname -s)" || echo --exclude-kernfs)
    $(for ex in "${ncdu_excludes[@]}"; do
        echo --exclude "$ex"
    done)
)

# default ncdu exclusion arguments
alias ncdu_all="$ncdu \$ncdu_excl_flags"
compdef ncdu_all="$ncdu" &>/dev/null
