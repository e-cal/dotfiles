function zvm_after_init() {
    # Load FZF completions
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"

	bindkey "^l" vi-forward-word
	bindkey "^w" vi-forward-blank-word
    # bindkey '^h' backward-delete-word
    # bindkey "^j" vi-forward-char
	# bindkey "^h" vi-backward-word
    # bindkey "^r" fzf-history-widget

    # Alt-r -> Reload
    _reload() { BUFFER='[[ -n $VIRTUAL_ENV ]] && deactivate;exec zsh'; zle accept-line; }
    zle -N _reload
    bindkey "^[r" _reload

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

    # alt-. -> cdc
    _cd_cfg() { BUFFER="cdc"; zle accept-line }
    zle -N _cd_cfg
    bindkey "^[." _cd_cfg
    bindkey "^." _cd_cfg

    # alt-shift-. -> vc
    _v_cfg() { BUFFER="vc"; zle accept-line }
    zle -N _v_cfg
    bindkey "^[>" _v_cfg

    # C-s -> rgs
    _rgs() { BUFFER="rgs"; zle accept-line }
    zle -N _rgs
    bindkey "^s" _rgs

    # C-t -> toggleterm
    _toggleterm() { BUFFER="toggleterm"; zle accept-line }
    zle -N _toggleterm
    bindkey "^t" _toggleterm

    # C-a -> get last arg
    bindkey -s "^a" '!$^M' # last arg
}

function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd "k" up-line
    zvm_bindkey vicmd "j" down-line
}
