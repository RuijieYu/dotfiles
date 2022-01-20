# get the environment variables of a certain PID
envof() {
    tr '\0' '\n' < "/proc/$1/environ"
}
