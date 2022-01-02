alias "l"="COLUMNS=60 exa --group-directories-first --icons"
alias "ls"="l"
alias "la"="ls -a"
alias "ll"="exa -la --group-directories-first --no-permissions --no-time --git"
alias "lla"="exa -la --group-directories-first --git -h"
alias "lt"="exa --tree --level=2"
alias "lta"="exa -a --tree --level=2"
alias "tree"="exa -a --tree"
alias ".ls"="/usr/bin/ls"

alias "py"="python"
alias "ipy"="ipython --TerminalInteractiveShell.editing_mode=vi"
alias "lsvenvs"="ls ~/.local/share/virtualenvs"
alias "v"="nvim"
alias "e"="nvim"
alias "clear"="clear;triangles"
alias "open"='xdg-open'
alias "greps"='grep -ri'
alias "clip"='xclip -sel clip'
alias "mvdl"="mv ~/Downloads/mv/* ./"
alias "sshpi"="[[ $HOST = 'coeus' ]] && ssh pi@$PILOCAL || ssh pi@$(dig +short ecal.dev)"
alias "hist"="history | awk '{ \$1=\"\"; print }'| fzf"

# Use rsync instead of cp to get the progress and speed of copying.
# aliases['cp'] = ['rsync', '--progress', '--recursive', '--archive']

# Config
alias "aliases"="e $DOTFILES/.config/zsh/alias.zsh"

# Searching
alias "searchsys"="sudo find / 2>/dev/null | fzf -m --bind space:toggle"
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

# Abbreviations
alias "rg"="rg -S"
alias "tmux"="tmux -2"
alias "docker"="sudo docker"
alias "venv"="python -m venv"
alias "yarn"="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias "msf"="msfconsole --quiet -x \"db_connect $USER@msf\""

# System specific
alias "bat-stat"="sudo tlp-stat"

# Fun
alias "weather"="curl wttr.in -s | head -n -1"

# Other
alias ".hack"="/usr/bin/git --git-dir=/opt/.hack --work-tree=/opt"
alias luamake=/home/ecal/projects/lua-language-server/3rd/luamake/luamake
alias "prolog"="swipl"
alias "xae"="setxkbmap us"
