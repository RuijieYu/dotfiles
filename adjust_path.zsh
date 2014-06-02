# Remove $1 from path $2, e.g.
#   remove_from_path PATH ~/bin
#   remove_from_path PYTHONPATH ~/lib/python2.7/site-packages
function remove_from_path() {
  local a
  local p
  local s
  local r
  eval "p=\$$1"  # get value of specified path
  a=( ${(s/:/)p} )  # turn it into an array
  # return if $2 isn't in path
  if [[ ${a[(i)${2}]} -gt ${#a} ]] && return
  # rebuild path from elements not matching $2
  for s in $a; do
    if [[ ! $s == $2 ]]; then
      [[ -z "$r" ]] && r=$s || r="$r:$s"
    fi
  done
  eval $1="$r"
}

# Add path to start of named path, removing any occurences
# already in it, e.g.
#   prepend_path PATH ~/bin
#   prepend_path PYTHONPATH ~/my-py-stuff
function prepend_path() {
  # Exit if directory doesn't exit
  [[ ! -d "$2" ]] && return
  local p
  remove_from_path "$1" "$2"
  eval "p=\$$1"
  eval export $1="$2:$p"
}

# As above, but add to end of path
function append_path() {
  # Exit if directory doesn't exit
  [[ ! -d "$2" ]] && return
  local p
  remove_from_path "$1" "$2"
  eval "p=\$$1"
  eval export $1="$p:$2"
}