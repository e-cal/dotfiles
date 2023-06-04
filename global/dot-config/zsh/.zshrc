source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/bindkey.zsh

# Load direnv
eval "$(direnv hook zsh)"

# Load prompt
eval "$(starship init zsh)"
