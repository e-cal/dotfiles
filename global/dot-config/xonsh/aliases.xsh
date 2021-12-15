# Core
aliases['..'] = "cd .."
aliases['la'] = "exa -la --color=always --group-directories-first"
aliases['cda'] = "cd $arg0 && la"
aliases['py'] = "python"
aliases['envs'] = "ls ~/.local/share/virtualenvs"
aliases['newenv'] = 'vox new $arg0; echo $arg0 > .venv; vox activate $arg0; pip install pynvim'
aliases['v'] = "nvim"
aliases['clear'] = "clear; triangles"
aliases['open'] = 'xdg-open'
aliases['greps'] = 'grep -ri'
aliases['clip'] = 'xclip -sel clip'
aliases['mvdl'] = 'mv ~/Downloads/@($arg0) $arg1'

# Use rsync instead of cp to get the progress and speed of copying.
# aliases['cp'] = ['rsync', '--progress', '--recursive', '--archive']

# Functions - TODO
aliases['vs'] = "nvimsearch"
aliases['cds'] = "cdsearch"

# Config
aliases['dotfiles'] = "cda $DOTFILES"
aliases['config'] = "cda $DOTFILES/.config"
aliases['zshrc'] = "v $DOTFILES/.config/zsh"
aliases['xonshrc'] = "v $DOTFILES/.config/xonsh"
aliases['alias'] = "v $DOTFILES/.config/xonsh/aliases.xsh"
aliases['nvimconf'] = "cda $DOTFILES/.config/nvim"
aliases['wmconfig'] = "nvim $DOTFILES/.config/xmonad/xmonad.hs"
aliases['xconfig'] = "nvim $DOTFILES/.config/X11/xinitrc"
aliases['fishconf'] = "cda $DOTFILES/.config/fish"

# Searching
aliases['searchsys'] = "sudo find / 2>/dev/null | fzf"
aliases['pacsearch'] = "pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print $2}\")' | xargs -ro sudo pacman -S"
aliases['aursearch'] = "yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print $2}\")' | xargs -ro  yay -S"

# Git
aliases['lg'] = "lazygit"
aliases['gs'] = "git status"
aliases['gf'] = "git fetch"
aliases['gr'] = "git fetch; git pull"
aliases['conflicts'] = "nvim (git diff --name-only | uniq)"

# Uni
aliases['cduni'] = "cda ~/Dropbox/uni/3F"
aliases['cd324'] = "cda ~/Dropbox/uni/3F/cisc324/"
aliases['cd360'] = "cda ~/Dropbox/uni/3F/cisc360/"
aliases['cd452'] = "cda ~/Dropbox/uni/3F/cisc452/"
aliases['cd221'] = "cda ~/Dropbox/uni/3F/comm221/"
aliases['cd271'] = "cda ~/Dropbox/uni/3F/psyc271/"
aliases['cd204'] = "cda ~/Dropbox/uni/3F/cisc204/"

# Util
aliases['fixkeys'] = "setxkbmap code-dvorak"
aliases['launchbar'] = "~/.config/polybar/launch.sh"
aliases['killbar'] = "kill (ps -e | rg poly | awk '{print $1}')"
aliases['fixap'] = "pacmd list-cards | grep 'Bean Pods' -m 1 -B 5 | head -1 | awk '{print $2}' | xargs -I % pacmd set-card-profile % a2dp_sink"

# Abbreviations
aliases['rg'] = "rg -S"
aliases['tmux'] = "tmux -2"
aliases['docker'] = "sudo docker"
aliases['venv'] = "python -m venv"
aliases['yarn'] = "yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
aliases['msf'] = "msfconsole --quiet -x \"db_connect $USER@msf\""

# System specific
aliases['battery'] = "acpi"
aliases['bat-stat'] = "sudo tlp-stat"

# Fun
aliases['weather'] = "curl wttr.in -s | head -n -1"
aliases['triangles'] = r"yes '△▽' | head -n @(int($(tput cols))//2) | tr '\n' ',' | sed 's/,//g' | lolcat -F 0.03"

# Other
aliases['.hack'] ='/usr/bin/git --git-dir=/opt/.hack --work-tree=/opt' # remove