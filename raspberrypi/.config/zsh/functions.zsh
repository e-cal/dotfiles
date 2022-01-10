cda() {
    cd $1
    la
}

cds() {
    if [[ $# > 0 ]]; then
        searchFrom=$1
    else
        searchFrom="."
    fi
    dir=`find $searchFrom -maxdepth 5 -type d 2>/dev/null | sed 's/\.\///' | fzf --border --height=50% --layout=reverse`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}

cdh() {
    if [[ $# > 0 ]]; then
        searchFrom="$HOME/$1"
    else
        searchFrom="$HOME"
    fi
    dir=`find $searchFrom -maxdepth 5 -type d 2>/dev/null | sed 's/\/home\/ecal\///' | sed 's/\/home\/ecal/home/' | fzf --border --height=50% --layout=reverse`
    if [[ ! -z $dir ]]; then
        if [[ $dir == "home" ]]; then
            cda $HOME
        else
            cda $HOME/$dir
        fi
    fi
}

cde() {
    dirs=(
        dotfiles $STOW_DIR
        config $DOTFILES/.config
        nvim $DOTFILES/.config/nvim
        scripts $STOW_DIR/global/scripts
        uni ~/Dropbox/uni/3F
        projects ~/projects
    )
    dir=`printf "%s %s\n" $dirs | fzf --with-nth 1 --border --height=20% --layout=reverse | awk '{print $2}'`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}

uni() {
    courses=(
        paradigms cisc360
        os cisc324
        nn cisc452
        comm comm221
        psyc psyc271
        ta cisc204
    )
    dir=`printf "%s %s\n" $courses | fzf --with-nth 1 | awk '{print $2}'`
    if [[ ! -z $dir ]]; then
        name=$courses[$(($courses[(i)$dir] - 1))]
        cd "$HOME/Dropbox/uni/3F/$dir"
        tm attach $name
        cd - &>/dev/null
    fi
}

mkscript() {
    if [[ -z $1 ]]; then
        name=`read -p "script name: "`
    else
        name=$1
    fi
    echo "#!/usr/bin/env bash\n" > $name
    chmod +x $name
    v $name
}

mkvenv() {
    if [[ -z $1 ]]; then
        name=`read -p "venv name: "`
    else
        name=$1
    fi
    venv "$VIRTUALENV_HOME/$name"
    echo $name > .venv
    source "$VIRTUALENV_HOME/$name/bin/activate"
    pip install pynvim black
}

setvenv() {
    if [[ -z $1 ]]; then
        name=`/usr/bin/ls $VIRTUALENV_HOME | fzf --header "virtual envs"`
    else
        name=$1
        [[ ! `/usr/bin/ls $VIRTUALENV_HOME` =~ .*"$name".* ]] && name=`/usr/bin/ls $VIRTUALENV_HOME | fzf --header "virtual envs"`
    fi
    echo $name > .venv
}

rmvenv() {
    echo not implemented
}

fixap() {
    pacmd list-cards | grep 'Bean Pods' -m 1 -B 5 | head -1 | xargs | awk '{print $2}' | xargs -I % pacmd set-card-profile % a2dp_sink
}

icat() {
    if [[ -z $TMUX ]]; then
        kitty +kitten icat $@
    else
        echo "Cannot display images in tmux."
    fi
}
