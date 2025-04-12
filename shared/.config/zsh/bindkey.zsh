function zvm_after_init() {
    # Load FZF completions
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"

    bindkey "${terminfo[kcuu1]}" history-search-backward
    bindkey "${terminfo[kcud1]}" history-search-forward

	bindkey "^l" vi-forward-word
	bindkey "^w" vi-forward-blank-word

    # Alt-r -> Reload
    _reload() { BUFFER='[[ -n $VIRTUAL_ENV ]] && deactivate;exec zsh'; zle accept-line; }
    zle -N _reload
    bindkey "^[r" _reload

    # C-k -> Clear
    _clear() { BUFFER="clear"; zle accept-line }
    zle -N _clear
    bindkey "^k" _clear

    # C-o -> ranger_cd
    _ranger_cd() { BUFFER="ranger_cd"; zle accept-line }
    zle -N _ranger_cd
    bindkey "^o" _ranger_cd

    # C-e -> explorer
    _explorer() { BUFFER="n"; zle accept-line }
    zle -N _explorer
    bindkey "^e" _explorer

    # alt-. -> cdc
    _cd_cfg() { BUFFER="cdc"; zle accept-line }
    zle -N _cd_cfg
    bindkey "^[." _cd_cfg
    bindkey "^." _cd_cfg

    # C-s -> rgs
    _rgs() { BUFFER="rgs"; zle accept-line }
    zle -N _rgs
    bindkey "^s" _rgs

    # C-t -> toggleterm
    _toggleterm() { BUFFER="toggleterm"; zle accept-line }
    zle -N _toggleterm
    bindkey "^t" _toggleterm

    # C-a -> get last arg
    bindkey -s "^a" '!$'


    # C-f -> fix command
    _fix() {
      echo -e "\n\033[1;33mFixing command...\033[0m"
      local result=$(fix "$cmd")
      local result=$(fix "$BUFFER")
      echo -e "\033[1A\033[2K"
      BUFFER="$result"
      CURSOR=${#BUFFER}
      zle redisplay
    }
    zle -N _fix
    bindkey "^f" _fix
    bindkey -M vicmd "^f" _fix
}

function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd "k" up-line
    zvm_bindkey vicmd "j" down-line
}
