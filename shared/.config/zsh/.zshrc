source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/bindkey.zsh

# Load zoxide and alias cd
eval "$(zoxide init zsh --cmd cd)"
eval "$(direnv hook zsh)"

# Start display server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    Hyprland
fi

# Load prompt
eval "$(starship init zsh)"

TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(starship module time)$(starship module character)'
# TRANSIENT_PROMPT_TRANSIENT_RPROMPT='$(starship module time)'

source $HOME/.config/zsh/plugins.zsh
