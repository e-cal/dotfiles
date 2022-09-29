gco() {
    if [[ $# == 0 ]]; then
        git checkout $(gb --format "%(refname:short)" | fzf)
    elif [[ $1 == "-r" ]]; then
        git checkout $(gb -r --format "%(refname:short)" | sed "s/^origin\///" | tail -n+2 | fzf)
    else
        git checkout "$@"
    fi
}

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
        config $STOW_DIR/global/dot-config
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


setvenv() {
    if [[ -z $1 ]]; then
        name=`/usr/bin/ls $VIRTUALENV_HOME | fzf --header "virtual envs"`
    else
        name=$1
        [[ ! `/usr/bin/ls $VIRTUALENV_HOME` =~ .*"$name".* ]] && name=`/usr/bin/ls $VIRTUALENV_HOME | fzf --header "virtual envs"`
    fi
	[[ -z $name ]] || echo $name > .venv
}

mkkernel() {
    if [[ -f ".venv" ]]; then
        pip install jupyter ipykernel jupytext jupyter_contrib_nbextensions jupyterthemes jupyter_nbextensions_configurator
        name=`cat .venv`
        python -m ipykernel install --name="$name" --user
		jupyter nbextensions_configurator enable
		jupyter contrib nbextensions install --user
		jupyter nbextension enable collapsible_headings/main
    else
        echo "no venv in current dir"
    fi
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

mknote() {
	cp -r ~/.dotfiles/global/dot-config/obsidian .obsidian-new
	if [[ -d ".obsidian" ]]; then
		cp .obsidian/workspace obsidian-workspace.bak
		rm -r .obsidian
		mv obsidian-workspace.bak .obsidian-new/workspace
	fi
	mv .obsidian-new .obsidian
}

conflicts() {
	files=`git diff --name-only | uniq`
	echo "$files" | xargs -d "\n" nvim
}

jtt() {
    if [[ -z $2 ]]; then
        ft="${1##*.}"
        kernel=""
        [[ $ft == "py" ]] && jupytext $1 --to ipynb --set-kernel -
        [[ $ft == "ipynb" ]] && jupytext $1 --to py:percent
    else
        jupytext $1 --to $2
    fi
}
