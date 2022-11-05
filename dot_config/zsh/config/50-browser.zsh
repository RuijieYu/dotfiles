found qutebrowser && {
    export BROWSER=qutebrowser
    systemctl --user import-environment BROWSER
}
