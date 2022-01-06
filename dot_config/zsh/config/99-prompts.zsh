# Target look:
#
# USERNAME@HOSTNAME <SHLVL> [RETVAL] NAMED-PATH $
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

__theme_load() {
    # load colors
    autoload -Uz colors && colors

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

    # $
    PS1+="$(__user_color '%(!.#.$)') "
}

__theme_load
