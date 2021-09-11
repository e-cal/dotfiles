#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

HISTSIZE=5000
HISTFILESIZE=5000
PATH=$HOME/scripts:$PATH
#BAT="acpi | awk '{print $4}' | sed 's/%,//g'"
XDG_CONFIG_HOME=/home/ecal/.config

alias la='ls -la --color=auto'
alias vim='nvim'
alias v='nvim'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Starship prompt
eval "$(starship init bash)"
