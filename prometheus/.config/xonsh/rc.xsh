# Paths
$DOTFILES = p"$HOME/.dotfiles/prometheus"
$XONSHRC_DIR = p"$DOTFILES/.config/xonsh"

# Settings
$VI_MODE = True
$HISTCONTROL = 'ignoredups' # ignore duplicate commands in history
$MULTILINE_PROMPT = ' ' # remove multiline dots
$AUTO_CD = True # allow typing path to cd
$DOTGLOB = True # include dotfiles in globs


# load xontrib packages
_xontribs = [
    'whole_word_jumping', # enable <C-Left> and <C-Right>
    # 'output_search',    # Get words from the previous command output for the next command. URL: https://github.com/tokenizer/xontrib-output-search
    # 'pipeliner',        # Let your pipe lines flow thru the Python code. URL: https://github.com/anki-code/xontrib-pipeliner
    # 'argcomplete',      # Tab completion of python and xonsh scripts. URL: https://github.com/anki-code/xontrib-argcomplete
    # 'onepath',          # Associate files with app and run it without preceding commands. URL: https://github.com/anki-code/xontrib-onepath
    # 'sh',               # Paste and run commands from bash, zsh, fish, tcsh in xonsh shell. URL: https://github.com/anki-code/xontrib-sh

# other
# https://github.com/laloch/xontrib-fzf-widgets
# https://github.com/ajeetdsouza/zoxide
# https://github.com/xxh/xxh-shell-xonsh
]
xontrib load @(_xontribs)


execx($(starship init xonsh))
