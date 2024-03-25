autoload -Uz compinit
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/bindkey.zsh

fignore=(.ipynb)

# Load prompt
eval "$(starship init zsh)"

# Load zoxide and alias cd
eval "$(zoxide init zsh --cmd cd)"

# Start display server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    # startx "$XDG_CONFIG_HOME"/X11/xinitrc
    Hyprland
fi
