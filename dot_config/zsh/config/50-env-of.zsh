# get the environment variables of a certain PID
_tr() {
    tr '\0' '\n'
}

envof() {
    _tr < "/proc/$1/environ"
}

cmdof() {
    _tr < "/proc/$1/cmdline"
}
