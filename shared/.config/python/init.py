import os
import atexit
import readline

histdir = os.path.join(os.path.expanduser("~"), ".local/share/python/")
histfile = os.path.join(histdir, "histfile")

try:
    readline.read_history_file(histfile)
    readline.set_history_length(10000)
except FileNotFoundError:
    os.makedirs(histdir, exist_ok=True)
    f = open(histfile, "w")
    f.close()
except OSError:
    print("Error opening history file, wiping and creating new")
    os.makedirs(histdir, exist_ok=True)
    f = open(histfile, "w")
    f.close()



print("Using histfile: ", histfile)
atexit.register(readline.write_history_file, histfile)
