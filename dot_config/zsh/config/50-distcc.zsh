found distcc || return

# distcc
enable_distcc() {
    prepend_path PATH /usr/lib/distcc/bin

    export DISTCC_HOSTS DISTCC_VERBOSE
}

disable_distcc () {
    remove_from_path PATH /usr/lib/distcc/bin

    typeset +x DISTCC_HOSTS DISTCC_VERBOSE
}
