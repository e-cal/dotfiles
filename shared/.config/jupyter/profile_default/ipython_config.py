from pygments.styles import get_style_by_name
from pygments.util import ClassNotFound

c = get_config()  # type: ignore # noqa

c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.editor = "nvim"
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalInteractiveShell.confirm_exit = False

c.TerminalInteractiveShell.shortcuts = [
    {
        "command": "IPython:auto_suggest.accept",
        "match_keys": ["right"],
    },

]

c.TerminalInteractiveShell.true_color = True
try:
    c.TerminalInteractiveShell.highlighting_style = get_style_by_name("catppuccin-mocha")
except ClassNotFound as ex:
    print(f"Failed to set theme: {ex}")

