# Core
alias "la"="exa -la --color=always --group-directories-first"
alias "py"="python"
alias "envs"="ls ~/.local/share/virtualenvs"
#alias "newenv"='vox new $arg0; echo $arg0 > .venv; vox activate $arg0; pip install pynvim'
alias "v"="nvim"
alias "clear"="clear;triangles"
alias "open"='xdg-open'
alias "greps"='grep -ri'
alias "clip"='xclip -sel clip'

# Use rsync instead of cp to get the progress and speed of copying.
# aliases['cp'] = ['rsync', '--progress', '--recursive', '--archive']

# Config
alias "zshrc"="v $DOTFILES/.config/zsh"
alias "aliases"="v $DOTFILES/.config/zsh/alias.zsh"

alias "dotfiles"="cda $DOTFILES"
alias "config"="cda $DOTFILES/.config"
alias "nvimconf"="cda $DOTFILES/.config/nvim"

alias "prompt"="v $DOTFILES/.config/starship.toml"
alias "wmconfig"="v $DOTFILES/.config/xmonad/xmonad.hs"
alias "xconfig"="v $DOTFILES/.config/X11/xinitrc"
alias "xonshrc"="v $DOTFILES/.config/xonsh"
alias "fishconf"="v $DOTFILES/.config/fish"

# Searching
alias "searchsys"="sudo find / 2>/dev/null | fzf"
alias "pacsearch"="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print $2}\")' | xargs -ro sudo pacman -S"
alias "aursearch"="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print $2}\")' | xargs -ro  yay -S"

# Git
alias "lg"="lazygit"
alias "gs"="git status"
alias "conflicts"="nvim (git diff --name-only | uniq)"

# Uni
alias "cduni"="cda ~/Dropbox/uni/3F"
alias "cd324"="cda ~/Dropbox/uni/3F/cisc324/"
alias "cd360"="cda ~/Dropbox/uni/3F/cisc360/"
alias "cd452"="cda ~/Dropbox/uni/3F/cisc452/"
alias "cd221"="cda ~/Dropbox/uni/3F/comm221/"
alias "cd271"="cda ~/Dropbox/uni/3F/psyc271/"
alias "cd204"="cda ~/Dropbox/uni/3F/cisc204/"

# Util
alias "fixkeys"="setxkbmap code-dvorak"
alias "launchbar"="~/.config/polybar/launch.sh"
alias "fixap"='pacmd list-cards | grep "Bean Pods" -m 1 -B 5 | head -1 | awk "{print $2}" | xargs -I % pacmd set-card-profile % a2dp_sink'

# Abbreviations
alias "rg"="rg -S"
alias "tmux"="tmux -2"
alias "docker"="sudo docker"
alias "venv"="python -m venv"
alias "yarn"="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias "msf"="msfconsole --quiet -x \"db_connect $USER@msf\""

# System specific
alias "battery"="acpi"
alias "bat-stat"="sudo tlp-stat"

# Fun
alias "weather"="curl wttr.in -s | head -n -1"

# Other
alias ".hack"="/usr/bin/git --git-dir=/opt/.hack --work-tree=/opt"
alias luamake=/home/ecal/projects/lua-language-server/3rd/luamake/luamake