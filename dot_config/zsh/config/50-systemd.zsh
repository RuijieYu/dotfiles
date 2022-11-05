readonly _systemd=(
    # single-letter aliases
    'b=bootctl'
    'h=hostnamectl'
    'j=journalctl'
    'm=machinectl'
    'n=networkctl'
    'r=resolvectl'
    's=systemctl'
    't=timedatectl'
    # systemd-* aliases
    'sm=systemd-mount'
    'sum=systemd-umount'
    'sr=systemd-run' # ref: https://serverfault.com/a/979654
)

alias "${_systemd[@]}"
