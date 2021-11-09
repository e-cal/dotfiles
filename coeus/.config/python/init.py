import os
import atexit
import readline

histdir = os.path.join(os.path.expanduser("~"), ".local/share/python/")
histfile = os.path.join(histdir, "histfile")

try:
    readline.read_history_file(histfile)
    readline.set_history_length(10000)
except FileNotFoundError:
    try:
        f = open(histfile, "w")
        f.close()
    except FileNotFoundError:
        os.mkdir(histdir)
        f = open(histfile, "w")
        f.close()


print("Using histfile: ", histfile)
atexit.register(readline.write_history_file, histfile)

"""
import atexit
import os
import readline
histfile = os.path.join(os.path.expanduser("~"), ".python_history")

try:
    readline.read_history_file(histfile)
    h_len = readline.get_current_history_length()
except FileNotFoundError:
    open(histfile, 'wb').close()
    h_len = 0

def save(prev_h_len, histfile):
    new_h_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    readline.append_history_file(new_h_len - prev_h_len, histfile)
atexit.register(save, h_len, histfile)
"""
