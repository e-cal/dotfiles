export TERM="screen-256color"
export TERMINAL="kitty"

# Useful vars
[[ -z $HOSTNAME ]] && [[ -n $HOST ]] && export HOSTNAME=$HOST
export DOTFILES=~/.dotfiles/$HOSTNAME
export STOW_DIR=~/.dotfiles
export EDITOR=nvim
export PILOCAL="192.168.2.186"

# XDG path spec
export XDG_CONFIG_HOME=~/.config
export CONFIG=$XDG_CONFIG_HOME
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

# zsh
export ZSH_COMPDUMP="$XDG_CACHE_HOME"/zsh/compdump
export HISTFILE="$XDG_CACHE_HOME"/zsh/history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
export PROMPT_EOL_MARK=""
export PS2="  "
export ZVM_CURSOR_STYLE_ENABLED=false

# fzf
export FZF_DEFAULT_COMMAND='rg -l ""'
export FZF_DEFAULT_OPTS='--prompt=" " --pointer="›" --bind tab:down,shift-tab:up,ctrl-y:preview-up,ctrl-e:preview-down'
export FZF_INLINE='--border --height=50% --layout=reverse --no-info'

export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG="p:preview-tui"

# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init.py
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export PYENV_ROOT="$XDG_CONFIG_HOME"/pyenv

# lemme use things
export PATH=$HOME/.local/bin:$HOME/scripts:$PYENV_ROOT/bin:$PATH:$XDG_DATA_HOME/cargo/bin

# GET OUT OF MY HOUSE
export XMONAD_CONFIG_HOME="$XDG_CONFIG_HOME"/xmonad
export XMONAD_DATA_HOME="$XDG_DATA_HOME"/xmonad
export XMONAD_CACHE_HOME="$XDG_CACHE_HOME"/xmonad
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export LESSHISTFILE="$XDG_DATA_HOME"/lesshst
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode # Could break vscode
export VSCODE="$XDG_DATA_HOME"/vscode # Could break vscode
export XONSHRC_DIR="$DOTFILES"/.config/xonsh
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export NVM_DIR="$XDG_DATA_HOME"/nvm
export MATLAB_LOG_DIR="$XDG_CACHE_HOME"/matlab/logs
export VIRTUALFISH_HOME="$HOME"/.local/share/virtualenvs
export VIRTUALENV_HOME="$HOME"/.local/share/virtualenvs
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export KAGGLE_CONFIG_DIR="$HOME"/projects/kaggle
export npm_config_nodedir="$XDG_DATA_HOME"/node
export SSB_HOME="$XDG_DATA_HOME"/zoom
export GOPATH="$XDG_DATA_HOME"/go
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export AIRFLOW_HOME="$HOME"/projects/praxis/airflow/airflow
export PSQLRC="$XDG_CONFIG_HOME"/pg/psqlrc
export PSQL_HISTORY="$XDG_DATA_HOME"/pg/psql_history
export PGPASSFILE="$XDG_CONFIG_HOME"/pg/pgpass
export PGSERVICEFILE="$XDG_CONFIG_HOME"/pg/pg_service.conf
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker


# Start X
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    startx "$XDG_CONFIG_HOME"/X11/xinitrc
fi
