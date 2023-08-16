alias "ls"='COLUMNS=$((`tput cols` - (`tput cols` / 10))) exa --group-directories-first --icons'
alias "la"="ls -a"
alias "ll"="exa -la --group-directories-first --no-permissions --no-time --git --color=always"
alias "lla"="exa -la --group-directories-first --git -h --color=always"
alias "lt"="exa --tree --level=2 --group-directories-first --sort=size --color=always | less"
alias "lta"="exa -a --tree --level=2 --group-directories-first --sort=size --color=always | less"
alias "tree"="exa -a --tree --group-directories-first --sort=size --color=always -I .git"
alias ".ls"="/usr/bin/ls"

alias "clear"="clear;divider"
alias "v"="nvim"
alias "vc"='nvim $(cfgdirs file)'
alias "vr"="nvim -c 'OpenLast'"
alias "py"="python"
alias "ipy"="ipython --TerminalInteractiveShell.editing_mode=vi"
alias "jn"="jupyter notebook"
alias "celar"="clear"
alias "yeet"="paru -Rsn"
alias "top"="bashtop"
alias "lsvenvs"="ls ~/.local/share/virtualenvs"
alias "lskernels"="ls $HOME/.local/share/jupyter/kernels"
alias "greps"='grep -ri'
alias "clip"='xclip -sel clip'
alias "sshpi"='[[ $HOST = "coeus" ]] && ssh pi@$PILOCAL || ssh pi@$(dig +short ecal.dev)'
alias "hist"="history | awk '{ \$1=\"\"; print }'| fzf"
alias "mvdl"="mv ~/Downloads/mv/* ./"
alias "pdfeditor"="masterpdfeditor4"
alias "diff"="kitty +kitten diff"
alias "openbar"="eww -c ~/.config/eww/bar open bar"
alias "closebar"="eww -c ~/.config/eww/bar close bar"
alias "code"="code-insiders"

# Searching
alias "searchsys"="sudo find / 2>/dev/null | fzf -m --bind space:toggle | head -c-1 | clip"
alias "pacsearch"="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print $2}\")' | xargs -ro sudo pacman -S"
alias "aursearch"="paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print $2}\")' | xargs -ro  paru -S"
alias "psrg"="ps -ef | rg"

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
alias "aoeu"="setxkbmap us"
alias "asdf"="setxkbmap code-dvorak"

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
alias "untar"="tar -xvf"
alias "bat"="bat -n"

# System specific
alias "bat-stat"="sudo tlp-stat"

# Other
alias "prolog"="swipl"

alias "testlocm"="python ~/projects/macq/tests/extract/test_locm.py"

# Working with dirs
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d
