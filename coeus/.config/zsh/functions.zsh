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
    dir=`find $searchFrom -type d | fzf`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}

vs() {
    if [[ $# > 0 ]]; then
        searchFrom=$1
    else
        searchFrom="."
    fi
    file=`find $searchFrom -type f | fzf --preview "bat --theme=gruvbox-dark --color=always {}"`
    if [[ ! -z $file ]]; then
        nvim $file
    fi
}

cde() {
    dirs=(
        dotfiles $DOTFILES
        projects ~/projects
        uni ~/Dropbox/uni/3F
        config $DOTFILES/.config
    )
    dir=`printf "%s %s\n" $dirs | fzf --with-nth 1 | awk '{print $2}'`
    if [[ ! -z $dir ]]; then
        cda $dir
    fi
}

ve() {
    files=(
        nvim $DOTFILES/.config/nvim
        zsh $DOTFILES/.config/zsh

        starship $DOTFILES/.config/starship.toml
        xmonad $DOTFILES/.config/xmonad/xmonad.hs
        x11 $DOTFILES/.config/X11/xinitrc

        alacritty $DOTFILES/.config/alacritty/alacritty.yml
        xonsh $DOTFILES/.config/xonsh
        fish $DOTFILES/.config/fish
    )
    file=`printf "%s %s\n" $files | fzf --with-nth 1 | awk '{print $2}'`
    if [[ ! -z $file ]]; then
        nvim $file
    fi
}

pass() {
  if [[ ! -z $BW_SESSION ]]; then
    bw get item "$(bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzf-tmux | awk '{print $(NF -0)}' | sed 's/\"//g')" | jq '.login.password' | sed 's/\"//g' | xclip -sel clip
  fi
}
