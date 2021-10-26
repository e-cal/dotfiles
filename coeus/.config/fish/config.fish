# triangles

# Exports
set fish_greeting # Disable default welcome message
set -Ux EDITOR /usr/bin/nvim
set -Ux VISUAL /usr/bin/nvim
set -Ux LC_ALL en_US.UTF-8
set -Ux LC_CTYPE en_US.UTF-8
set -Ux STOW_DIR $HOME/.dotfiles
set PATH $HOME/.local/bin $HOME/scripts /opt/bin /opt/bin/2john $PATH
#set FZF_DEFAULT_COMMAND = 'rg --files --hidden --no-ignore-vcs'

# Shell Mode
function fish_user_key_bindings
  fish_default_key_bindings
  # fish_vi_key_bindings
end

# Cursor
# not supported in alacritty
set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual block

# Autocomplete and Highlight Colors
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan


# Keybindings for !! and !$
if [ $fish_key_bindings = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Starship prompt
starship init fish | source

# Initiate ssh session and add keys
echo
fssh
