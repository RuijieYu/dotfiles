# get the environment variables of a certain PID
tr_nl() tr '\0' '\n'

envof() tr_nl <"/proc/$1/environ"

cmdof() tr_nl <"/proc/$1/cmdline"
