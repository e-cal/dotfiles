gco() {
    if [[ $# == 0 ]]; then
        git checkout $(gb --format "%(refname:short)" | fzf)
    elif [[ $1 == "-r" ]]; then
        git checkout $(gb -r --format "%(refname:short)" | sed "s/^origin\///" | tail -n+2 | fzf)
    else
        git checkout "$@"
    fi
}

cdc() {
    dir=`common`
    [[ ! -z $dir ]] && cd $dir
}

nvc() {
    file=`common file`
    if [[ ! -z $file ]]; then
        cd `dirname $file`
        nvim $file
    fi
}

mkkernel() {
    if [[ -f ".venv" ]]; then
        uv pip install jupyter ipykernel jupyter_contrib_nbextensions jupyterthemes jupyter_nbextensions_configurator jupyter_ascending
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

conflicts() {
	files=`git diff --name-only | uniq`
    echo "$files"
	# echo "$files" | xargs -d "\n" nvim
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

ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}
