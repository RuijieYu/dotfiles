# customize prompts
function __if() {
    # $1: an integer, 0 means true, others means false
    # $2: output string if true
    # $3: output string if false
    if test "$1" -eq 0; then
        echo "$2"
    else
        echo "$3"
    fi
}

function __is_root() {
    test "$(whoami)" = root
    echo $?
}

function __get_user_color() {
    __if "$(__is_root)" \
	 "$fg[red]" \
	 "$fg[green]"
}

export PS1="%{$(__get_user_color)%}%n%{$reset_color%}@%{$fg[green]%}%M%{$reset_color%} %~ %{$(__get_user_color)%}%#%{$reset_color%} "
export RPS1="[%?]"

