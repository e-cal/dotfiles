# Core
aliases['..'] = "cd .."
aliases['la'] = "exa -la --color=always --group-directories-first"
aliases['cda'] = "cd $arg0 && la"
aliases['py'] = "python"
aliases['vim'] = "nvim"
aliases['v'] = "nvim"
aliases['hist'] = "history | fzf"
aliases['clear'] = r"/bin/clear && triangles"
# Use rsync instead of cp to get the progress and speed of copying.
# aliases['cp'] = ['rsync', '--progress', '--recursive', '--archive']
aliases['greps'] = 'grep -ri'
aliases['clp'] = 'xclip -sel clip'

# Functions
aliases['vs'] = "nvimsearch"
aliases['cds'] = "cdsearch"

# Config
aliases['dotfiles'] = "cda $DOTFILES"
aliases['config'] = "cda $DOTFILES/.config"
aliases['xonshrc'] = "v $DOTFILES/.config/xonsh"
aliases['alias'] = "v $DOTFILES/.config/xonsh/rc.d/aliases.xsh"
aliases['nvimconfig'] = "cda $DOTFILES/.config/nvim"
aliases['wmconfig'] = "nvim $DOTFILES/.config/xmonad/xmonad.hs"

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
aliases['uni'] = "cda ~/Dropbox/uni"
aliases['cd324'] = "cda ~/Dropbox/uni/3F/cisc324/"
aliases['cd360'] = "cda ~/Dropbox/uni/3F/cisc360/"
aliases['cd452'] = "cda ~/Dropbox/uni/3F/cisc452/"
aliases['cd221'] = "cda ~/Dropbox/uni/3F/comm221/"
aliases['cd271'] = "cda ~/Dropbox/uni/3F/psyc271/"

# Util
aliases['fixkeys'] = "setxkbmap code-dvorak"
aliases['launchbar'] = "~/.config/polybar/launch.sh"
aliases['killbar'] = "kill (ps -e | rg poly | awk '{print $1}')"

# Other
aliases['triangles'] = r"yes '△▽' | head -n @(int($(tput cols))//2) | tr '\n' ',' | sed 's/,//g' | lolcat -F 0.03"
aliases['battery'] = "acpi"
aliases['bat-stat'] = "sudo tlp-stat"
aliases['docker'] = "sudo docker"
aliases['yarn'] = "yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
aliases['hackenv'] = "source /home/ecal/.local/share/virtualenvs/hackenv-lLLAxNNd/bin/activate.fish"
aliases['.hack'] ='/usr/bin/git --git-dir=/opt/.hack --work-tree=/opt'
aliases['rg'] = "rg -S"
aliases['msf'] = "msfconsole --quiet -x \"db_connect $USER@msf\""
aliases['venv'] = "python -m venv"
aliases['update'] = "yay -Syyu"
aliases['crontab'] = "fcrontab"
aliases['tmux'] = "tmux -2"
aliases['funcs'] = "cd ~/.config/fish/functions && la"
aliases['fishconf'] = "cd ~/.config/fish && la"

