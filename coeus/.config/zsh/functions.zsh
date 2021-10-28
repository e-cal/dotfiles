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
    dir=`find $searchFrom -type d -maxdepth 3 | sed 's/\.\///' | fzf`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}

cde() {
    dirs=(
        dotfiles $DOTFILES
        config $DOTFILES/.config
        uni ~/Dropbox/uni/3F
        projects ~/projects
    )
    dir=`printf "%s %s\n" $dirs | fzf --with-nth 1 | awk '{print $2}'`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}
