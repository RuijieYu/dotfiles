readonly _systemd=(
    'b=bootctl'
    'h=hostnamectl'
    'j=journalctl'
    'm=machinectl'
    'n=networkctl'
    'r=resolvectl'
    's=systemctl'
    't=timedatectl'
    'sm=systemd-mount'
    'sum=systemd-umount'
)

alias "${_systemd[@]}"
