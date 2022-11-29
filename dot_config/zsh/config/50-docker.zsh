# logic for docker

# consider docker to actually run podman when either a symlink, or
# a shell script executing podman
__docker_is_podman() {
    local __docker="$(whence docker 2>/dev/null)" || return 1
    test podman = "$(basename "$(realpath "$__docker")")" && return 0
    file "$__docker" | grep -q 'POSIX shell script' || return 1
    # exec /usr/bin/podman "$@"
    grep -Pq 'exec\s.*podman' "$__docker"
}

# stop if neither docker nor podman is installed
found podman || found docker || return

__podman_installed() { found podman; }

__docker_installed() { found docker && ! __docker_is_podman; }

__sudo() {
    case "$USER!$1" in
    root!-v) ;;
    root!*) "$@" ;;
    *) sudo $(sudo -Av && echo -A) "$@" ;;
    esac
}

docker() {
    if __docker_installed; then
        # docker is installed
        __sudo =docker "$@"
    elif __docker_is_podman; then
        # docker is alias for podman
        local arg1="$1"
        shift
        case "$arg1" in
        compose) __sudo ="podman-$arg1" "$@" ;;
        *) __sudo =podman "$arg1" "$@" ;;
        esac
    else
        # docker not installed
        return 127
    fi
}

if __docker_is_podman; then
    # when docker is an alias of podman
    compdef docker=podman
fi

docker-compose-restart() {
    local projdir compose \
        projs=($(print -l "$@" | sort | uniq | while read projdir; do
            test -r "$projdir/docker-compose.yml" && echo "$projdir"
        done)) \
        down=(down $DOWN_ARGS) \
        up=(up --pull=always --build --remove-orphans --detach --wait $UP_ARGS)

    (
        __sudo -v

        (
            for projdir in "${projs[@]}"; do
                compose=(compose --project-directory="$projdir" $COMPOSE_ARGS)
                docker "${compose[@]}" "${down[@]}" | cat &
            done
            wait
        )

        (
            for projdir in "${projs[@]}"; do
                compose=(compose --project-directory="$projdir" $COMPOSE_ARGS)
                docker "${compose[@]}" "${up[@]}" | cat &
            done
            wait
        )
    )
}
