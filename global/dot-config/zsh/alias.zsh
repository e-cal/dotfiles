# Auto flags
alias "rg"="rg -S"
alias "tmux"="tmux -2"
alias "docker"="sudo docker"
alias "yarn"="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias "bat"="bat -n"

alias "md"="mkdir -p"
alias "mvdl"="mv ~/Downloads/mv/* ./"
alias "cddl"="cd ~/Downloads"
alias "v"="nvim"
alias "vr"="nvim -c 'RestoreSession'"
alias "vl"="nvim -c 'OpenLast'"

alias "clear"="clear;divider"
alias "celar"="clear"
alias "hist"="history | awk '{ \$1=\"\"; print }'| fzf"
alias "psrg"="ps -ef | rg"

alias "sshpi"='[[ $HOST = "coeus" ]] && ssh pi@$PILOCAL || ssh pi@$(dig +short ecal.dev)'
alias "pdfeditor"="masterpdfeditor4"
alias "code"="code-insiders"
alias "untar"="tar -xvf"

alias "yeet"="paru -Rsn"
alias "pacsearch"="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print $2}\")' | xargs -ro sudo pacman -S"
alias "aursearch"="paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print $2}\")' | xargs -ro  paru -S"

alias "py"="python"
alias "ipy"="ipython"
alias "jn"="jupyter notebook"
alias "lsvenvs"="ls ~/.local/share/virtualenvs"
alias "lskernels"="ls $HOME/.local/share/jupyter/kernels"
alias "venv"="python -m venv"
alias "pynb"="jupytext --to ipynb"
alias "nbpy"="jupytext --to py"

alias "ls"='COLUMNS=$((`tput cols` - (`tput cols` / 10))) exa --group-directories-first --icons'
alias "la"="ls -a"
alias "lr"="ls -R"
alias "ll"="exa -lah --group-directories-first --no-permissions --no-time --no-user --git --color=always"
alias "lla"="exa -la --group-directories-first --git -h --color=always"
alias "lt"="exa --tree --level=2 --group-directories-first --sort=size --color=always -I .git | bat --style=plain"
alias "lta"="exa -a --tree --level=2 --group-directories-first --sort=size --color=always | bat --style=plain"
alias "tree"="exa -a --tree --group-directories-first --sort=size --color=always -I .git"
alias ".ls"="/usr/bin/ls"
alias "less"="bat --style=plain"

alias "gitalias"="alias | rg 'git' | fzf $FZF_INLINE"
alias "gs"="git status"
alias "gwa"="git worktree add"
alias "gpc"='git --no-pager log -1 --color=always --pretty="%C(dim brightblack)(%ah)%n%Creset%Cblue%an:%Creset %B%Creset"'
alias "gpr"='git pull --rebase; echo; gpc'
alias "gpra"='git pull --rebase --autostash; echo; gpc'
alias "gprs"='git pull --rebase --autostash; echo; gpc'
alias "gb"='git --no-pager branch'
alias "gP"='git pull'
alias "lg"="lazygit"

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

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d
