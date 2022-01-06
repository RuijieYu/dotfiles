# use fzf

declare _FZF_VERSION _FZF_KEYBINDING

# find fzf for brew, return 1 otherwise
__fzf_reload_version() {
    # only dynamic under homebrew
    __brew_prefix || return 1
    # procedure requres jq for json parsing
    test jq &>/dev/null || {
        echo '"jq" needs to be installed on brew'
        return
    } >&2
    # assign fzf version variable
    _FZF_VERSION="$(
        brew info fzf --json |
        jq '.[0]["installed"][0]["version"]' |
        cut -d\" -f2
    )"
}

# find fzf keybind for brew, return 1 otherwise
__fzf_get_kb_file() {
    # first get the version if unavailable, return 1 if not
    # using brew
    test -n "$_FZF_VERSION" ||
        __fzf_reload_version ||
        return 1
    # assign fzf kb filename using obtained fzf version
    _FZF_KEYBINDING="$(brew --prefix)/Cellar/fzf/${_FZF_VERSION}/shell/key-bindings.zsh"
}

__fzf_get_kb_file_cached() {
    # check brew
    __brew_prefix || return 1
    
    # specify fzf path
    _FZF_KEYBIND_CACHE="$XDG_CACHE_HOME/zsh_fzf_keybindings"
    
    if test -r "$_FZF_KEYBIND_CACHE"; then
        # if fzf keybind file cached, then try to use that
        # path, and if file does not exist, try to get
        # filename again
        _FZF_KEYBINDING="$(<"$_FZF_KEYBIND_CACHE")"
        # file exists, done
        test -r "$_FZF_KEYBINDING" && return
    fi

    # when either the cache is invalid or there is no cache,
    # fetch the keybind file anew and dump the info to the
    # cache file
    __fzf_get_kb_file || return 1
    
    # if fzf keybind file cached, then try to use that path
    # dump this value to cache
    printf '%s' "$_FZF_KEYBINDING" > \
           "$_FZF_KEYBIND_CACHE"    
}

# if not brew, set default
__fzf_get_kb_file_cached ||
    _FZF_KEYBINDING=/usr/share/fzf/key-bindings.zsh

# source this file if exists
test ! -r "$_FZF_KEYBINDING" ||
    source "$_FZF_KEYBINDING"
