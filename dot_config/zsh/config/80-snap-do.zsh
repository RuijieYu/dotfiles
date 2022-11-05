# do the same thing for each snapshot.  Make sure PWD is at the
# root of a snapshot-enabled subvolume, and the snapshot is
# managed by snapper at $SUBVOLUME/.snapshots . The actions are
# passed to multiple invocations of "sh -c".
snap-do() {
	test $# -eq 0 -o "$1" = -h -o "$1" = --help && {
		print -l \
			"$0 [-h]" "$0 <cmd> [<req-rw>] [<sudo-cmd>] [<sync>] [<count>]" \
			'' \
			"<cmd>       Command to execute per snapshot, passed to \"sh -c\"." \
			"<req-rw>    Nonempty if requesting read-write permission." \
			"<sudo-cmd>  Provide a sudo executable name to prepend property modification command." \
			"<sync>      Nonempty if actions should be done synchronously." \
			"<count>     (Debug use.) Stop after <count> times if it is positive. [default: 0]"
		return
	}

	# $1: passed to sh -c;
	# $2: nonempty if the command requires writing;
	# $3: nonempty for the sudo command (probably just "sudo") for toggling read-only and read-write permissions;
	# $4: nonempty for synchronous (default async)
	# $5: limit count (debug purposes)
	local sudo="$3" rw="$2" cmd="$1" limit=$(($5)) sync="$4"
	limit=$((limit > 0 ? limit : 0))
	-snap-sudo() {
		if test -n "$sudo"; then
			"$sudo" "$@"
		else
			"$@"
		fi
	}
	-snap-single() {
		# $1: current snapshot subvolume
		local subv="$1" prevrw

		if test -n "$rw"; then
			-snap-lock() {
				prevrw="$(btrfs property get "$subv" ro |
					awk -F= '{print $2}')"
				-snap-sudo btrfs property set "$subv" ro false
			}
			-snap-unlock() {
				-snap-sudo btrfs property set "$subv" ro "$prevrw"
			}
		else
			-snap-lock() :
			-snap-unlock() :
		fi

		# make sure subvolume is made read-write if requested
		-snap-lock

		# run the command with PWD at subvolume
		pushd "$subv" &>/dev/null
		sh -c "$cmd"
		popd &>/dev/null

		# make sure subvolume has reverted permission
		-snap-unlock
	}

	# warn the user
	print -l \
		"About to execute: « $cmd » on each snapshot volume!" \
		"Write permissions requested? $(
			test -z "$rw"
			echo $?
		)" \
		"Permission elevator: « $sudo »" \
		"Repeat count (debug): $((limit))"
	echo -n "Proceed? [y/N] "
	read -q || return $?
    echo

	for snap in .snapshots/*/snapshot; do
		if test -z "$sync"; then
			(-snap-single "$snap" &)
		else
			-snap-single "$snap"
		fi

		test 1 -eq $((limit)) && return 0
	done
}
