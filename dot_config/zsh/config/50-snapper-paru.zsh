# exit if no pacman or no snapper
found pacman && found snapper || return

# root snapshot config name
ROOT_SNAP="${ROOT_SNAP:-@}"
SUDO_CMD="${SUDO_CMD:-sudo}"

# for snapshotted package management
#
# ROOT_SNAP: root snapshot config name
# SUDO_CMD: space-separated list of arguments for elevation
snap-paru() {
	# snap-paru [-c CONFIG] ARGS...
	local snap="-c$ROOT_SNAP"
	case "$1" in
	-c | --config)
		snap="-c$2"
		shift 2
		;;
	-c* | --config=*)
		snap="$1"
		shift
		;;
	esac

	# assuming that I can call snapper -c@ ... without elevation,
	# e.g., by allowing group wheel.

	# detect when paru is unavailable
	local cmd=()
	if found paru; then
		cmd+=(paru)
	else
		cmd+=($SUDO_CMD pacman)
	fi

	# append additional arguments
	cmd+=("$@")

	# per zsh's parsing, "$cmd" combines everything into a single
	# arg
	snapper "$snap" \
		create \
		-c empty-pre-post \
		-d "run: $cmd" \
		--command "$cmd"
}

if found paru; then
	compdef snap-paru=paru
else
	compdef snap-paru=pacman
fi

# for checking package changes between two snapshots (usually a
# pre-snapshot and a post-snapshot), assuming that both are valid
# snapshots and `snapper [-cCONFIG] status PRE..POST` outputs
# diff.
snap-pkgdiff() {
	# snap-pkgdiff [-c CONFIG] PRE [POST]
	local snap="-c$ROOT_SNAP"
	case "$1" in
	-c | --config)
		snap="-c$2"
		shift 2
		;;
	-c* | --config=*)
		snap="$1"
		shift
		;;
	esac

	local pre post
	# $1: pre snapshot
	pre=$(($1))
	# $2: post snapshot [default = PRE+1]
	post=$(($(($2)) ? $(($2)) : pre + 1))

	snapper "$snap" \
		status \
		$((pre))..$((post)) |
		grep /var/lib/pacman/.\*/desc |
		awk -F/ '{ print $1 $(NF-1) }'
}
