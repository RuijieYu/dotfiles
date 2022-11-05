# $1 = pid to wait for
tailwait() {
    local pid="$1"
    shift
    tail --quiet --follow --pid="$pid" "$@"
} </dev/null

WAIT_URGENCY="${WAIT_URGENCY:-critical}"
# wait for $1 and then notify
wait_notify() {
    local urgency="${2:-$WAIT_URGENCY}"
    tailwait "$1"
    notify-send -u "$urgency" "PID $1 finishes"
}
