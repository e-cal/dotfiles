autoload -Uz compinit
compinit

GIT_AUTO_FETCH_INTERVAL=300 # auto-fetch every 5m
zstyle :omz:plugins:ssh-agent identities id_ed25519
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

declare -A plugins
plugins=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
        ["zsh-vi-mode"]="https://github.com/jeffreytse/zsh-vi-mode"
        ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
    )

if [[ ! -d "$HOME/.config/zsh/plugins" ]]; then
    mkdir -p "$HOME/.config/zsh/plugins"
fi

for plugin in "${(@k)plugins}"; do
    if [[ ! -d "$HOME/.config/zsh/plugins/$plugin" ]]; then
        git clone "${plugins[$plugin]}" "$HOME/.config/zsh/plugins/$plugin"
    fi
    # no ".plugin" infix
    if [[ "$plugin" == "zsh-autosuggestions" ]]; then
        source "$HOME/.config/zsh/plugins/$plugin/$plugin.zsh"
        continue
    fi
    source "$HOME/.config/zsh/plugins/$plugin/$plugin.plugin.zsh"
done

# -----------------------------------------------------------------------------
#                                   Autovenv
# -----------------------------------------------------------------------------
function _virtualenv_auto_activate() {
    if [[ -f ".venv" ]]; then
        _VENV_PATH=$VIRTUALENV_HOME/$(cat .venv)

        if [[ "$VIRTUAL_ENV" != $_VENV_PATH ]]; then
            source $_VENV_PATH/bin/activate
        fi

    elif (( ${+VIRTUAL_ENV} )); then
        deactivate
    fi
}

function venvconnect (){
    if [[ -n $VIRTUAL_ENV ]]; then
        echo $(basename $VIRTUAL_ENV) > .venv
    else
        echo "Activate a virtualenv first"
    fi
}

chpwd_functions+=(_virtualenv_auto_activate)
precmd_functions=(_virtualenv_auto_activate $precmd_functions)

# -----------------------------------------------------------------------------
#                                Git auto-fetch
# -----------------------------------------------------------------------------

# Default auto-fetch interval: 60 seconds
: ${GIT_AUTO_FETCH_INTERVAL:=60}

# Necessary for the git-fetch-all function
zmodload zsh/datetime
zmodload -F zsh/stat b:zstat  # only zstat command, not stat command

function git-fetch-all {
  (
    # Get git root directory
    if ! gitdir="$(command git rev-parse --git-dir 2>/dev/null)"; then
      return 0
    fi

    # Do nothing if auto-fetch is disabled or don't have permissions
    if [[ ! -w "$gitdir" || -f "$gitdir/NO_AUTO_FETCH" ]] ||
       [[ -f "$gitdir/FETCH_LOG" && ! -w "$gitdir/FETCH_LOG" ]]; then
      return 0
    fi

    # Get time (seconds) when auto-fetch was last run
    lastrun="$(zstat +mtime "$gitdir/FETCH_LOG" 2>/dev/null || echo 0)"
    # Do nothing if not enough time has passed since last auto-fetch
    if (( EPOCHSECONDS - lastrun < $GIT_AUTO_FETCH_INTERVAL )); then
      return 0
    fi

    # Fetch all remotes (avoid ssh passphrase prompt)
    date -R &>! "$gitdir/FETCH_LOG"
    GIT_SSH_COMMAND="command ssh -o BatchMode=yes" \
    GIT_TERMINAL_PROMPT=0 \
      command git fetch --all 2>/dev/null &>> "$gitdir/FETCH_LOG"
  ) &|
}

function git-auto-fetch {
  # Do nothing if not in a git repository
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0

  # Remove or create guard file depending on its existence
  local guard="$(command git rev-parse --git-dir)/NO_AUTO_FETCH"
  if [[ -f "$guard" ]]; then
    command rm "$guard" && echo "${fg_bold[green]}enabled${reset_color}"
  else
    command touch "$guard" && echo "${fg_bold[red]}disabled${reset_color}"
  fi
}

# zle-line-init widget (don't redefine if already defined)
(( ! ${+functions[_git-auto-fetch_zle-line-init]} )) || return 0

case "$widgets[zle-line-init]" in
# Simply define the function if zle-line-init doesn't yet exist
  builtin|"") function _git-auto-fetch_zle-line-init() {
      git-fetch-all
    } ;;
# Override the current zle-line-init widget, calling the old one
  user:*) zle -N _git-auto-fetch_orig_zle-line-init "${widgets[zle-line-init]#user:}"
    function _git-auto-fetch_zle-line-init() {
      git-fetch-all
      zle _git-auto-fetch_orig_zle-line-init -- "$@"
    } ;;
esac

zle -N zle-line-init _git-auto-fetch_zle-line-init

# -----------------------------------------------------------------------------
#                                     Git
# ----------------------------------------------------------------------------- 
# Git version checking
autoload -Uz is-at-least
git_version="${${(As: :)$(git version 2>/dev/null)}[3]}"

#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function current_branch() {
  git_current_branch
}

# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
compdef _git _git_log_prettily=git-log

# Warn if the current branch is a WIP
function work_in_progress() {
  command git -c log.showSignature=false log -n 1 2>/dev/null | grep -q -- "--wip--" && echo "WIP!!"
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo develop
}

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'

alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch --delete 2>/dev/null'
alias gbD='git branch --delete --force'
alias gbg='git branch -vv | grep ": gone\]"'
alias gbgd='local res=$(gbg | awk '"'"'{print $1}'"'"') && [[ $res ]] && echo $res | xargs git branch -d'
alias gbgD='local res=$(gbg | awk '"'"'{print $1}'"'"') && [[ $res ]] && echo $res | xargs git branch -D'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcam='git commit --all --message'
alias gcsm='git commit --signoff --message'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcb='git checkout -b'
alias gcf='git config --list'

function gccd() {
  command git clone --recurse-submodules "$@"
  [[ -d "$_" ]] && cd "$_" || cd "${${_:t}%.git}"
}
compdef _git gccd=git-clone

alias gcl='git clone --recurse-submodules'
alias gclean='git clean --interactive -d'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout $(git_develop_branch)'
alias gcmsg='git commit --message'
# alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog --summary --numbered'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit --gpg-sign'
alias gcss='git commit --gpg-sign --signoff'
alias gcssm='git commit --gpg-sign --signoff --message'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'

function gdnolock() {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}
compdef _git gdnolock=git-diff

function gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff

alias gf='git fetch'
# --jobs=<n> was added in git 2.8
is-at-least 2.8 "$git_version" \
  && alias gfa='git fetch --all --prune --jobs=10' \
  || alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias gfg='git ls-files | grep'

alias gg='git gui citool'
alias gga='git gui citool --amend'

function ggf() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force origin "${b:=$1}"
}
compdef _git ggf=git-checkout
function ggfl() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force-with-lease origin "${b:=$1}"
}
compdef _git ggfl=git-checkout

function ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}
compdef _git ggl=git-checkout

function ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}
compdef _git ggp=git-checkout

function ggpnp() {
  if [[ "$#" == 0 ]]; then
    ggl && ggp
  else
    ggl "${*}" && ggp "${*}"
  fi
}
compdef _git ggpnp=git-checkout

function ggu() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout

alias ggpur='ggu'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
is-at-least 2.30 "$git_version" \
  && alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes' \
  || alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease'

alias ghh='git help'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

alias gk='\gitk --all --branches &!'
alias gke='\gitk --all $(git log --walk-reflogs --pretty=%h) &!'

alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat --patch'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp="_git_log_prettily"

alias gm='git merge'
alias gmom='git merge origin/$(git_main_branch)'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'
alias gma='git merge --abort'
alias gms="git merge --squash"

alias gp='git push'
alias gpd='git push --dry-run'
is-at-least 2.30 "$git_version" \
  && alias gpf='git push --force-with-lease --force-if-includes' \
  || alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias gpr='git pull --rebase'
# alias gpu='git push upstream'
alias gpv='git push --verbose'

alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase --interactive'
alias grbm='git rebase $(git_main_branch)'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote --verbose'

alias gsb='git status --short --branch'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status --short'
alias gst='git status'

# use the default stash push on git 2.13 and newer
is-at-least 2.13 "$git_version" \
  && alias gsta='git stash push' \
  || alias gsta='git stash save'

alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gstall='git stash --all'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch --create'
alias gswm='git switch $(git_main_branch)'
alias gswd='git switch $(git_develop_branch)'

alias gts='git tag --sign'
alias gtv='git tag | sort -V'
alias gtl='gtl(){ git tag --sort=-v:refname -n --list "${1}*" }; noglob gtl'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase --verbose'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash --verbose'
alias gupom='git pull --rebase origin $(git_main_branch)'
alias gupomi='git pull --rebase=interactive origin $(git_main_branch)'
alias glum='git pull upstream $(git_main_branch)'
alias gluc='git pull upstream $(git_current_branch)'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

unset git_version


# -----------------------------------------------------------------------------
#                                  SSH Agent
# -----------------------------------------------------------------------------
# Get the filename to store/lookup the environment from
ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

function _start_agent() {
  # Check if ssh-agent is already running
  if [[ -f "$ssh_env_cache" ]]; then
    . "$ssh_env_cache" > /dev/null

    # Test if $SSH_AUTH_SOCK is visible
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  # Set a maximum lifetime for identities added to ssh-agent
  local lifetime
  zstyle -s :omz:plugins:ssh-agent lifetime lifetime

  # start ssh-agent and setup environment
  zstyle -t :omz:plugins:ssh-agent quiet || echo >&2 "Starting ssh-agent ..."
  ssh-agent -s ${lifetime:+-t} ${lifetime} | sed '/^echo/d' >! "$ssh_env_cache"
  chmod 600 "$ssh_env_cache"
  . "$ssh_env_cache" > /dev/null
}

function _add_identities() {
  local id file line sig lines
  local -a identities loaded_sigs loaded_ids not_loaded
  zstyle -a :omz:plugins:ssh-agent identities identities

  # check for .ssh folder presence
  if [[ ! -d "$HOME/.ssh" ]]; then
    return
  fi

  # add default keys if no identities were set up via zstyle
  # this is to mimic the call to ssh-add with no identities
  if [[ ${#identities} -eq 0 ]]; then
    # key list found on `ssh-add` man page's DESCRIPTION section
    for id in id_rsa id_dsa id_ecdsa id_ed25519 identity; do
      # check if file exists
      [[ -f "$HOME/.ssh/$id" ]] && identities+=($id)
    done
  fi

  # get list of loaded identities' signatures and filenames
  if lines=$(ssh-add -l); then
    for line in ${(f)lines}; do
      loaded_sigs+=${${(z)line}[2]}
      loaded_ids+=${${(z)line}[3]}
    done
  fi

  # add identities if not already loaded
  for id in $identities; do
    # if id is an absolute path, make file equal to id
    [[ "$id" = /* ]] && file="$id" || file="$HOME/.ssh/$id"
    # check for filename match, otherwise try for signature match
    if [[ ${loaded_ids[(I)$file]} -le 0 ]]; then
      sig="$(ssh-keygen -lf "$file" | awk '{print $2}')"
      [[ ${loaded_sigs[(I)$sig]} -le 0 ]] && not_loaded+=("$file")
    fi
  done

  # abort if no identities need to be loaded
  if [[ ${#not_loaded} -eq 0 ]]; then
    return
  fi

  # pass extra arguments to ssh-add
  local args
  zstyle -a :omz:plugins:ssh-agent ssh-add-args args

  # if ssh-agent quiet mode, pass -q to ssh-add
  zstyle -t :omz:plugins:ssh-agent quiet && args=(-q $args)

  # use user specified helper to ask for password (ksshaskpass, etc)
  local helper
  zstyle -s :omz:plugins:ssh-agent helper helper

  if [[ -n "$helper" ]]; then
    if [[ -z "${commands[$helper]}" ]]; then
      echo >&2 "ssh-agent: the helper '$helper' has not been found."
    else
      SSH_ASKPASS="$helper" ssh-add "${args[@]}" ${^not_loaded} < /dev/null
      return $?
    fi
  fi

  ssh-add "${args[@]}" ${^not_loaded}
}

# Add a nifty symlink for screen/tmux if agent forwarding is enabled
if zstyle -t :omz:plugins:ssh-agent agent-forwarding \
   && [[ -n "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
  ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USERNAME-screen
else
  _start_agent
fi

# Don't add identities if lazy-loading is enabled
if ! zstyle -t :omz:plugins:ssh-agent lazy; then
  _add_identities
fi

unset agent_forwarding ssh_env_cache
unfunction _start_agent _add_identities
