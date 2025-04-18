from pygments.styles import get_style_by_name
from pygments.util import ClassNotFound
import warnings
import os

c = get_config()  # noqa type: ignore

RED = "\033[31m"
ORANGE = "\033[38;5;208m"
RESET = "\033[0m"

# Custom virtualenv warning
def log_virtualenv_warning(message, category, filename, lineno, file=None, line=None):
    if "Attempting to work in a virtualenv" in str(message):
        os.environ['IPYTHON_VIRTUALENV_WARNING'] = '1'
        return None  # surpress warning
    return warnings.showwarning(message, category, filename, lineno, file, line)

warnings.showwarning = log_virtualenv_warning

virtualenv_message = f"{ORANGE}Warning: Working in a virtualenv environment without jupyter installed{RESET}"
if 'IPYTHON_VIRTUALENV_WARNING' in os.environ: del os.environ['IPYTHON_VIRTUALENV_WARNING']
c.InteractiveShellApp.exec_lines = [
    f"""import os
if os.environ.get('IPYTHON_VIRTUALENV_WARNING') == '1':
    print('{virtualenv_message}')
    del os.environ['IPYTHON_VIRTUALENV_WARNING']"""
]

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
