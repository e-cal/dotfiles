#!/usr/bin/env bash

if [[ $# = 0 ]]; then
    msg="Update"
else
    for w in $@; do
        msg+="$w "
    done
    msg=`echo $msg | head -c -1`
fi

cd $STOW_DIR
echo -e "\nPushing submodule updates..."
git submodule foreach "git add -A && git commit -m \"Updated with dotfiles: ($msg)\" && git push && echo" 2>/dev/null
echo -e "\nPushing dotfile updates..."
git add -A
git commit -m "$msg"
git push --recurse-submodules=on-demand
