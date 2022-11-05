# Add a convenience function to query for an executable with zero
# IO.  Note that this only looks in path, not aliases.
found() {
    whence -p -- "$@"
} </dev/null &>/dev/null

# Print the first found executable name from argument list.  The
# last executable name serves as a defualt value, so supply an
# empty arg if this is not desired.
first-found() {
    local arg
    for arg; do
        found "$arg" && {
            echo "$arg"
            return
        }
    done
    echo "$arg"
    return 1
}
