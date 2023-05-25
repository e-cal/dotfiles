alias "ls"='COLUMNS=$((`tput cols` - (`tput cols` / 10))) exa --group-directories-first --icons'
alias "la"="ls -a"
alias "ll"="exa -la --group-directories-first --no-permissions --no-time --git --color=always"
alias "lla"="exa -la --group-directories-first --git -h --color=always"
alias "lt"="exa --tree --level=2 --group-directories-first --sort=size --color=always | less"
alias "lta"="exa -a --tree --level=2 --group-directories-first --sort=size --color=always | less"
alias "tree"="exa -a --tree --group-directories-first --sort=size --color=always"
alias ".ls"="/usr/bin/ls"

alias "yeet"="paru -Rsn"
alias "top"="bashtop"
alias "py"="python"
alias "ipy"="ipython --TerminalInteractiveShell.editing_mode=vi"
alias "jn"="jupyter notebook"
alias "lsvenvs"="ls ~/.local/share/virtualenvs"
alias "lskernels"="ls $HOME/.local/share/jupyter/kernels"
alias "v"="nvim"
alias "vc"='nvim $(cfgdirs --file)'
alias "vr"="nvim -c 'OpenLast'"
alias "clear"="clear;triangles"
alias "celar"="clear"
alias "greps"='grep -ri'
alias "clip"='xclip -sel clip'
alias "sshpi"='[[ $HOST = "coeus" ]] && ssh pi@$PILOCAL || ssh pi@$(dig +short ecal.dev)'
alias "sshcloud"='ssh root@155.138.135.131'
alias "hist"="history | awk '{ \$1=\"\"; print }'| fzf"
alias "mvdl"="mv ~/Downloads/mv/* ./"
alias "mvimg"="mv ~/*.png ./"
alias "pdfeditor"="masterpdfeditor4"
alias "rss"="canto-curses"

# Searching
alias "searchsys"="sudo find / 2>/dev/null | fzf -m --bind space:toggle | head -c-1 | clip"
alias "pacsearch"="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print $2}\")' | xargs -ro sudo pacman -S"
alias "aursearch"="paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print $2}\")' | xargs -ro  paru -S"

# Git
alias "lg"="lazygit"
alias "gs"="git status"
alias "gitalias"="alias | rg 'git' | fzf $FZF_INLINE"
alias "gwa"="git worktree add"
alias "gpc"='git --no-pager log -1 --color=always --pretty="%C(dim brightblack)(%ah)%n%Creset%Cblue%an:%Creset %B%Creset"'
alias "gpr"='git pull --rebase;echo;gpc'
alias "gb"='git --no-pager branch'

# Util
alias "fixkeys"="setxkbmap code-dvorak"
alias "ygb"="setxkbmap code-dvorak"
alias "qwerty"="setxkbmap us"

# Abbreviations
alias "rg"="rg -S"
alias "tmux"="tmux -2"
alias "docker"="sudo docker"
alias "dcu"="sudo docker-compose up"
alias "dcd"="sudo docker-compose down"
alias "start-docker"="sudo systemctl start docker"
alias "stop-docker"="sudo systemctl stop docker"
alias "venv"="python -m venv"
alias "yarn"="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias "cddl"="cda ~/Downloads"
alias "untar"="tar xvzf"

# System specific
alias "bat-stat"="sudo tlp-stat"

# Fun
alias "weather"="curl wttr.in -s | head -n -1"

# Other
alias "prolog"="swipl"

alias "testlocm"="python ~/projects/macq/tests/extract/test_locm.py"

# Remove
unalias gco
unalias gpu
