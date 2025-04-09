function zvm_after_init() {
    # Load FZF completions
    source "$(fzf-share)/key-bindings.zsh"
    source "$(fzf-share)/completion.zsh"

    bindkey "${terminfo[kcuu1]}" history-search-backward
    bindkey "${terminfo[kcud1]}" history-search-forward

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
    bindkey -s "^a" '!$' # last arg


    # C-f -> fix command
    _fix() {
      # # Get the current command line text
      # BUFFER="fix \"${BUFFER}\""
      # # Move cursor to the end
      # CURSOR=${#BUFFER}
      # # Accept the command (equivalent to pressing Enter)
      # zle accept-line

      echo -e "\n\033[1;33mFixing command...\033[0m"
      
      # Run the fix command
      local result=$(fix "$cmd")
      
      # Clear the line with the message (moves cursor up and clears line)
      local result=$(fix "$BUFFER")

      # echo -e "\033[3A\033[2K\033[3B" # Move up 3 lines, clear line, move back down
      # zle reset-prompt
      # echo -e "\033[2K\033[1A\033[2K\033[1A\033[2K\033[2B" # Clear 3 lines
      # zle redisplay
      echo -e "\033[1A\033[2K"
      # zle reset-prompt

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
