# remove all empty directories under $@
rmdir_all () {
        find "$@" -type d -exec rmdir -pv {} +
}
