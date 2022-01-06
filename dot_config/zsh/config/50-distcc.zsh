# distcc
__use_distcc() {
    _prepend_path /usr/lib/distcc/bin
    
    # [[ "$PATH" =~ '.*distcc.*' ]] ||
    # export PATH="/usr/lib/distcc/bin:$PATH"
    
    export DISTCC_HOSTS="$DISTCC_HOSTS"
    export DISTCC_VERBOSE="$DISTCC_VERBOSE"
}
