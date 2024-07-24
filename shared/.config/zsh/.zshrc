source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/bindkey.zsh

# Load zoxide and alias cd
eval "$(zoxide init zsh --cmd cd)"

# Start display server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    Hyprland
fi

# Load prompt
eval "$(starship init zsh)"

# precmd_functions=(zvm_init "${(@)precmd_functions:#zvm_init}")
#
# preexec_functions+=(__starship_preexec)
# precmd_functions+=(__starship_precmd)
#
# set-long-prompt() {
#     PROMPT=$(starship prompt)
#     RPROMPT=""
# }
# precmd_functions+=(set-long-prompt)
#
# export COLUMNS=$(($COLUMNS + ($COLUMNS*0.1)))
# set-short-prompt() {
#     local keymap=${KEYMAP:-vicmd}
#     PROMPT="$(STARSHIP_KEYMAP=$keymap starship module character --status=$__starship_last_exit_status)"
#     RPROMPT=$'%{\e[999C%}\e[8D%F{8}%*%f '
#     zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
# }
#
# zle-keymap-select() {
#     set-short-prompt
# }
# zle -N zle-keymap-select
#
# zle-line-finish() { set-short-prompt }
# zle -N zle-line-finish
#
# zvm_after_init_commands+=("zle -N zle-line-finish; zle-line-finish() { set-short-prompt }")
#
# trap 'set-short-prompt; return 130' INT
#
# zvm_after_init_commands+=('
#   function zle-keymap-select() {
#     if [[ ${KEYMAP} == vicmd ]] ||
#        [[ $1 = "block" ]]; then
#       echo -ne "\e[1 q"
#       STARSHIP_KEYMAP=vicmd
#     elif [[ ${KEYMAP} == main ]] ||
#          [[ ${KEYMAP} == viins ]] ||
#          [[ ${KEYMAP} = "" ]] ||
#          [[ $1 = "beam" ]]; then
#       echo -ne "\e[5 q"
#       STARSHIP_KEYMAP=viins
#     fi
#     zle reset-prompt
#   }
#   zle -N zle-keymap-select
#
#   # Ensure vi mode is set
#   zle-line-init() {
#     zle -K viins
#     echo -ne "\e[5 q"
#   }
#   zle -N zle-line-init
# ')
