function zvm_after_init() {
    # Load FZF completions
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh

	bindkey "^l" vi-forward-word
	bindkey "^w" vi-forward-blank-word
    bindkey '^h' backward-delete-word
    bindkey "^j" vi-forward-char
	# bindkey "^h" vi-backward-word

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

    # C-e -> ranger
    _explorer() { BUFFER="n"; zle accept-line }
    zle -N _explorer
    bindkey "^e" _explorer

    # C-o -> cde
    _jump_shortlist() { BUFFER="cde"; zle accept-line }
    zle -N _jump_shortlist
    bindkey "^o" _jump_shortlist

    # C-t -> rgs
    _rgs() { BUFFER="rgs"; zle accept-line }
    zle -N _rgs
    bindkey "^t" _rgs

    # C-l -> la
    # _la() { BUFFER="la"; zle accept-line }
    # zle -N _la
    # bindkey "^l" _la

    # C-a -> get last arg
    bindkey -s "^a" '!$^M' # last arg

    # C-s -> bashtop
    _bashtop() { BUFFER="bashtop"; zle accept-line }
    zle -N _bashtop
    bindkey "^s" _bashtop
}

function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd "H" vi-beginning-of-line
    zvm_bindkey vicmd "L" vi-end-of-line
    zvm_bindkey visual "H" vi-beginning-of-line
    zvm_bindkey visual "L" vi-end-of-line

    zvm_bindkey vicmd "k" up-line
    zvm_bindkey vicmd "j" down-line
}
