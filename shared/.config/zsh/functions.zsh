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

cdc() {
    dir=`cfg cd`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}

nvc() {
    file=`cfg file`
    if [[ ! -z $file ]]; then
        cd `dirname $file`
        nvim $file
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


mkkernel() {
    if [[ -f ".venv" ]]; then
        pip install jupyter ipykernel jupyter_contrib_nbextensions jupyterthemes jupyter_nbextensions_configurator jupyter_ascending
        name=`cat .venv`
        python -m ipykernel install --name="$name" --user
		jupyter nbextensions_configurator enable
		jupyter contrib nbextensions install --user
		jupyter nbextension enable collapsible_headings/main

        jupyter nbextension install jupyter_ascending --sys-prefix --py
        jupyter nbextension enable jupyter_ascending --sys-prefix --py
        jupyter serverextension enable jupyter_ascending --sys-prefix --py
    else
        echo "no venv in current dir"
    fi
}

fixap() {
    pacmd list-cards | grep 'ePods' -m 1 -B 5 | head -1 | xargs | awk '{print $2}' | xargs -I % pacmd set-card-profile % a2dp_sink
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

mknb() {
    cat > "$1".sync.ipynb <<EOF
{
 "cells": [],
 "metadata": {
  "jupytext": {
   "cell_metadata_filter": "-all",
   "formats": "ipynb,py:percent",
   "notebook_metadata_filter": "-all"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
EOF
    echo "# %%" > "$1".sync.py
}

mvws() {
    hyprctl dispatch moveworkspacetomonitor "$1 DP-$2"
}

cursor() {
    if ! [[ -f ~/.local/bin/cursor.appimage ]]; then
        echo "Download cursor appimage to ~/.local/bin"
    fi

    runbg appimage-run ~/.local/bin/cursor.appimage $@
    # if [[ -z $IN_NIX_SHELL ]]; then
    # else
    #     echo "Exiting nix shell, try again"
    #     exit
    # fi
}

uvinit() {
    [[ -f .venv ]] && rm .venv
    uv init .
}

sourcevenv() {
    if [[ -f .venv ]]; then
        name=`cat .venv`
        source $VIRTUALENV_HOME/$name/bin/activate
    elif [[ -d .venv && -f .venv/bin/activate ]]; then
        source .venv/bin/activate
    else
        echo "No virtualenv found"
    fi
}
