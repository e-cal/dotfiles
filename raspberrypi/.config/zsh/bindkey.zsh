function zvm_after_init() {
    # Load FZF completions
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
    bindkey '^h' fzf-history-widget

    # C-r -> Reload
    _re_source() { BUFFER="exec zsh"; zle accept-line; }
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

    # C-j -> cdh
    _jump() { BUFFER="cdh"; zle accept-line }
    zle -N _jump
    bindkey "^j" _jump

    # C-e -> ve
    _special() { BUFFER="ve"; zle accept-line }
    zle -N _special
    bindkey "^e" _special

    # C-s -> cde
    _jump_shortlist() { BUFFER="cde"; zle accept-line }
    zle -N _jump_shortlist
    bindkey "^s" _jump_shortlist

    # C-t -> rgs
    _rgs() { BUFFER="rgs"; zle accept-line }
    zle -N _rgs
    bindkey "^t" _rgs

    # C-l -> la
    _la() { BUFFER="la"; zle accept-line }
    zle -N _la
    bindkey "^l" _la

    # C-a -> get last arg
    bindkey -s "^a" '!$^M' # last arg

    # C-g -> lg
    _lg() { BUFFER="lg"; zle accept-line }
    zle -N _lg
    bindkey "^g" _lg
}

function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd "H" vi-beginning-of-line
    zvm_bindkey vicmd "L" vi-end-of-line
    zvm_bindkey visual "H" vi-beginning-of-line
    zvm_bindkey visual "L" vi-end-of-line

    zvm_bindkey vicmd "k" up-line
    zvm_bindkey vicmd "j" down-line
}
