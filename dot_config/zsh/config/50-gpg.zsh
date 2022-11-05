# configure ssh -> gpg
## export names

gpg_setup() {
	# the tty to use
	export GPG_TTY="$(tty)"

	# the authentication socket to use
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

	# attach current tty to gpg-agent
	gpg-connect-agent updatestartuptty /bye

	# set SSH_AGENT_PID as the first PID of gpg-agent
	export SSH_AGENT_PID="$(pidof gpg-agent | cut '-d ' -f1)"
}

# no interaction allowed during gpg setup
#gpg_setup </dev/null &>/dev/null
