#!/usr/bin/env bash

no_fetch=false
args=""
for arg in $@; do
    if [[ $arg = "--no-fetch" || $arg = "-n" ]]; then
        no_fetch=true
    else
        args+="$arg "
    fi
done

cd $STOW_DIR
[[ $no_fetch = false ]] && git fetch
git status $args

