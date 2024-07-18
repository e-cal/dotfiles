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
