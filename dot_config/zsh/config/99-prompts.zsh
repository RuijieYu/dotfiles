# Target look:
#
# USERNAME@HOSTNAME <SHLVL> [RETVAL] NAMED-PATH [GIT-INFO] $
#
# Colored components:
# - Username, Hostname, "$"
# - - ssh + root, purple
# - - ssh + regular, cyan
# - - local + root, red
# - - local + regular, green
# - RETVAL
# - - 0, no color
# - - else, red
#
# Optional components:
# - <SHLVL>
# - - only show if (( SHLVL >= 2 ))
# - [RETVAL]
# - - only show if (( RETVAL != 0 ))
# - [GIT-INFO] TODO
# - - only show if ??
#
# Togglable components:
# - <SHLVL>
# - - when $XDG_CONFIG_HOME/zsh/flags/tty is nonempty,
# - -   display <SHLVL@TTYNAME> and is always visible,
# - -   and TTYNAME refers to the ttyname minus /dev/
# - - example: with SHLVL=2, TTYNAME=tty4, show <2@tty4>
# - BATTERY-PERCENTAGE% (after [RETVAL]) UNIMPLEMENTED
# - - when $XDG_CONFIG_HOME/zsh/flags/battery is nonemtpy
# - -   and at least one battery is detected, display
# - -   BATTERY-PERCENTAGE% of the first detected battery.
# - - dependency: /usr/bin/acpi

# return true (0) when flag $1 is toggled
__theme_check_flag() {
    test -z "$XDG_CONFIG_HOME" &&
        export XDG_CONFIG_HOME="$HOME/.config"
    test -s "$XDG_CONFIG_HOME/zsh/flags/$1"
}

# get the color name for the user components
__user_color_name() {
    if test -n "$SSH_CONNECTION"; then
        print -n '%(!.purple.cyan)'
    else
        print -n '%(!.red.green)'
    fi
}

# apply color to $1
__user_color() {
    print -n "%F{$(__user_color_name)}$1%f"
}

# function called for [GIT-INFO], whose stdout is used in the prompt
__git_info() {
    # [GIT-INFO]
    local h ch stat
    {
        # first, try to get a branch name
        h="$(git symbolic-ref --short HEAD)"
        ## color it blue
        test -n "$h" && h="%F{blue}$h%f"
        
        # if failed (empty h), then try to get a hash value
        test -z "$h" && h="$(git show -s --format=%h)"
        ## color it yellow
        test -n "$h" && h="%F{yellow}$h%f"
        
        # if empty h, then not at gitdir, exit; otherwise print it
        test -n "$h" || return 0
        echo -n "$h"

        # get current git status; ch is the list of change-flags
        # recognized from the git status
        stat="$(git status --porcelain=v1)"
        echo "$stat" | grep -qm1 '^M ' && ch+='%F{green}M%f' # staged modification
        echo "$stat" | grep -qm1 '^ M' && ch+='%F{red}M%f' # unstaged modification
        echo "$stat" | grep -qm1 '^D ' && ch+='%F{green}D%f' # staged deletion
        echo "$stat" | grep -qm1 '^ D' && ch+='%F{red}D%f' # unstaged deletion
        echo "$stat" | grep -qm1 '^R ' && ch+='%F{green}R%f' # staged rename
        echo "$stat" | grep -qm1 '^ R' && ch+='%F{red}R%f' # unstaged rename
        echo "$stat" | grep -qm1 '^C ' && ch+='%F{green}C%f' # staged copy
        echo "$stat" | grep -qm1 '^ C' && ch+='%F{red}C%f' # unstaged copy

        echo "$stat" | grep -qm1 '^\?\?' && ch+='%F{red}?%f' # untracked file

        local _ch
        _ch="$(echo "$stat" | grep -Pom1 '^[MDRU]{2}')" # conflicts
        echo "$stat" | grep -Pqm1 '^[MACTRUD]{2}' && ch+='%F{red}X%f' # conflicts

        
        # when ch nonempty, print it
        test -z "$ch" || echo -n " $ch"
        
        echo
    } |
        # wrap first line into [...]
        sed '{s/^/[/g; s/$/]/g};q' |
        # convert the trailing newline into a space
        tr '\n' ' '
} 2>/dev/null

__theme_load() {
    # load colors
    autoload -Uz colors && colors

    # this prompt line requires executing commands for each prompt
    setopt prompt_subst

    # clear PS1 and RPS1
    export PS1= RPS1=

    # USERNAME@HOSTNAME
    PS1+="$(__user_color %n)@"
    PS1+="$(__user_color %M) "

    # <SHLVL>
    if __theme_check_flag tty; then
        PS1+="<$SHLVL@%y> "
    elif test "$SHLVL" -gt 1; then
        PS1+="%(2L.<$SHLVL> .)"
    fi

    # [RETVAL]
    PS1+='%(?..[%F{red}%?%f] )'

    # BATTERY-PERCENTAGE% UNIMPLEMENTED

    # NAMED-PATH
    PS1+='%~ '

    # [GIT-INFO]
    PS1+='$(__git_info)'

    # $
    PS1+="$(__user_color '%(!.#.$)') "
}

__theme_load
