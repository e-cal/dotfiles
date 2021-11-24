function zvm_after_init() {
    source /usr/share/fzf/completion.zsh

    _re_source() { BUFFER="exec zsh"; zle accept-line; }
    zle -N _re_source
    bindkey "^r" _re_source

    _clear() { BUFFER="clear"; zle accept-line }
    zle -N _clear
    bindkey "^k" _clear

    _dir_files() { BUFFER="vs"; zle accept-line }
    zle -N _dir_files
    bindkey "^p" _dir_files

    _jump() { BUFFER="cds ~"; zle accept-line }
    zle -N _jump
    bindkey "^j" _jump

    _special() { BUFFER="ve"; zle accept-line }
    zle -N _special
    bindkey "^e" _special

    _jump_shortlist() { BUFFER="cde"; zle accept-line }
    zle -N _jump_shortlist
    bindkey "^s" _jump_shortlist

    _rgs() { BUFFER="rgs"; zle accept-line }
    zle -N _rgs
    bindkey "^t" _rgs

    bindkey "^l" up-history
    bindkey -s "^a" '!$^M'
}

function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd "H" vi-beginning-of-line
    zvm_bindkey vicmd "L" vi-end-of-line
    zvm_bindkey visual "H" vi-beginning-of-line
    zvm_bindkey visual "L" vi-end-of-line

    zvm_bindkey vicmd "k" up-line
    zvm_bindkey vicmd "j" down-line
}
