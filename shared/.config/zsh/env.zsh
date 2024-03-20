export TERM="xterm-kitty"
export TERMINAL="kitty"

# Useful vars
[[ -z $HOSTNAME ]] && [[ -n $HOST ]] && export HOSTNAME=$HOST
export DOTFILES="$HOME/.dotfiles"
export HOST_DOTFILES="$HOME/.dotfiles/$HOSTNAME"
export SHARED_DOTFILES="$HOME/.dotfiles/shared"
export EDITOR=nvim
export PILOCAL="192.168.2.186"

# XDG path spec
export XDG_CONFIG_HOME=~/.config
export CONFIG=$XDG_CONFIG_HOME
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

# Wayland things
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

if [[ $HOSTNAME == "gaius" ]] then
    export LIBVA_DRIVER_NAME=nvidia
    export XDG_SESSION_TYPE=wayland
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1

fi

# zsh
[[ -d "$XDG_CACHE_HOME"/zsh ]] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

export PROMPT_EOL_MARK=""
export PS2="  "
export ZVM_CURSOR_STYLE_ENABLED=false
export ZSH_COMPDUMP="$XDG_CACHE_HOME"/zsh/compdump
export HISTFILE="$XDG_CACHE_HOME"/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt appendhistory
setopt hist_verify


# fzf
export FZF_DEFAULT_COMMAND='rg -l ""'
export FZF_DEFAULT_OPTS='--prompt=" " --pointer="›" --bind tab:down,shift-tab:up,ctrl-y:preview-up,ctrl-e:preview-down --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
export FZF_INLINE='--border --height=50% --layout=reverse --no-info'

# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/init.py
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export PYENV_ROOT="$XDG_CONFIG_HOME"/pyenv

# lemme use things
export PATH=$HOME/.local/bin:$HOME/scripts:$PYENV_ROOT/bin:$XDG_DATA_HOME/cargo/bin:/opt/cuda-11.7/bin:$PATH
# export LD_LIBRARY_PATH=/opt/cuda/lib64:/opt/cuda-11.7/lib64:$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
export GTK_THEME=Adwaita:dark

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
export OPAMROOT="$XDG_DATA_HOME/opam"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
