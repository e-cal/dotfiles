alias "ls"='COLUMNS=$((`tput cols` - (`tput cols` / 10))) exa --group-directories-first --icons'
alias "la"="ls -a"
alias "ll"="exa -la --group-directories-first --no-permissions --no-time --git --color=always"
alias "lla"="exa -la --group-directories-first --git -h --color=always"
alias "lt"="exa --tree --level=2 --group-directories-first --sort=size --color=always | less"
alias "lta"="exa -a --tree --level=2 --group-directories-first --sort=size --color=always | less"
alias "tree"="exa -a --tree --group-directories-first --sort=size --color=always"
alias ".ls"="/usr/bin/ls"

alias "yeet"="yay -Rsn"
alias "top"="bashtop"
alias "py"="python"
alias "ipy"="ipython --TerminalInteractiveShell.editing_mode=vi"
alias "lsvenvs"="ls ~/.local/share/virtualenvs"
alias "v"="nvim"
alias "vr"="nvim -c 'Dashboard | Telescope oldfiles'"
alias "vS"="nvim -c 'SessionLoad'"
alias "clear"="clear;triangles"
alias "greps"='grep -ri'
alias "clip"='xclip -sel clip'
alias "sshpi"="[[ $HOST = 'coeus' ]] && ssh pi@$PILOCAL || ssh pi@$(dig +short ecal.dev)"
alias "hist"="history | awk '{ \$1=\"\"; print }'| fzf"
alias "mvdl"="mv ~/Downloads/mv/* ./"
alias "mvimg"="mv ~/*.png ./"

# Searching
alias "searchsys"="sudo find / 2>/dev/null | fzf -m --bind space:toggle"
alias "pacsearch"="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print $2}\")' | xargs -ro sudo pacman -S"
alias "aursearch"="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print $2}\")' | xargs -ro  yay -S"

# Git
alias "lg"="lazygit"
alias "gs"="git status"
alias "gitalias"="alias | rg 'git' | fzf $FZF_INLINE"
alias "gwa"="git worktree add"

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
alias "cddl"="cda ~/Downloads"

# System specific
alias "bat-stat"="sudo tlp-stat"

# Fun
alias "weather"="curl wttr.in -s | head -n -1"

# Other
# alias ".hack"="/usr/bin/git --git-dir=/opt/.hack --work-tree=/opt"
# alias luamake=/home/ecal/projects/lua-language-server/3rd/luamake/luamake
alias "prolog"="swipl"
alias "xae"="setxkbmap us"
