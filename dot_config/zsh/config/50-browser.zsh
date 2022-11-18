found qutebrowser && {
    export BROWSER=qutebrowser
    systemctl is-active user@"$UID" &&
        systemctl --user import-environment BROWSER
} &>/dev/null
