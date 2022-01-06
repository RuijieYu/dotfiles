# helper functions
__in_path() {
    # check whether $1 is in path
    test $path[(ie)$dir] -le $#path
}

# append directories to the list if it is not already
_append_path() {
    # will not append if it is already in the array
    for dir in "$@"; do
	if ! __in_path "$dir"; then
	    # $dir is not in path array
	    path+=("$dir")
	fi
    done
}

# prepend directories to the list
# if the directories already exist, remove later duplicates
# note that the last argument to this function
# will be at the front of the path array when the function returns
_prepend_path() {
    # will delete the original index if present?
    for dir in "$@"; do
	if ! __in_path "$dir"; then
	    # $dir is in path array
	    _erase_from_path "$dir"
	fi
	# prepend element
	# assuming that path is nonempty
	path[1]=("$dir" $path[1])
    done
}

# this function erases all occurences of elements from an array
_erase_from_path() {
    for arg in "$@"; do
	while true; do
	      local ind=$path[(Ie)$arg]
	      # finish when index = 0
	      test 0 -ne "$ind" || break
	      # remove the found element from array list
	      path[$ind]=()
	done
    done
}

# prepend the following items to path
_prepend_path "$HOME/.local/bin"

# append the following items to path
_append_path
