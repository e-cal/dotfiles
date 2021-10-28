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
        nvim $DOTFILES/.config/nvim
        uni ~/Dropbox/uni/3F
        projects ~/projects
    )
    dir=`printf "%s %s\n" $dirs | fzf --with-nth 1 | awk '{print $2}'`
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
        cda "$HOME/Dropbox/uni/3F/$dir"
    fi
}
