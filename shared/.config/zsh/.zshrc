source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/bindkey.zsh
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/prompt.zsh

eval "$(zoxide init zsh --cmd cd)"
eval "$(direnv hook zsh)"

# Start display server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    Hyprland
fi


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
