function zvm_after_init() {
    # Load FZF completions
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh

	bindkey "^l" vi-forward-word
	bindkey "^w" vi-forward-blank-word
    # bindkey '^h' backward-delete-word
    bindkey "^j" vi-forward-char
	# bindkey "^h" vi-backward-word
    bindkey "^h" fzf-history-widget

    # C-r -> Reload
    _re_source() { BUFFER='[[ -n $VIRTUAL_ENV ]] && deactivate;exec zsh'; zle accept-line; }
    zle -N _re_source
    bindkey "^r" _re_source

    # C-k -> Clear
    _clear() { BUFFER="clear"; zle accept-line }
    zle -N _clear
    bindkey "^k" _clear

    # C-p -> vs
    _dir_files() { BUFFER="vs"; zle accept-line }
    zle -N _dir_files
    bindkey "^p" _dir_files

    # C-o -> vr
    _open_last() { BUFFER="vr"; zle accept-line }
    zle -N _open_last
    bindkey "^o" _open_last

    # C-e -> explorer
    _explorer() { BUFFER="n"; zle accept-line }
    zle -N _explorer
    bindkey "^e" _explorer

    # C-. -> cdc
    _cd_cfg() { BUFFER="cdc"; zle accept-line }
    zle -N _cd_cfg
    bindkey "^[." _cd_cfg

    # C-t -> rgs
    _rgs() { BUFFER="rgs"; zle accept-line }
    zle -N _rgs
    bindkey "^t" _rgs

    # C-a -> get last arg
    bindkey -s "^a" '!$^M' # last arg
}

function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd "H" vi-beginning-of-line
    zvm_bindkey vicmd "L" vi-end-of-line
    zvm_bindkey visual "H" vi-beginning-of-line
    zvm_bindkey visual "L" vi-end-of-line

    zvm_bindkey vicmd "k" up-line
    zvm_bindkey vicmd "j" down-line
}
