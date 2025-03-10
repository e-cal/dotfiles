import threading
from http.server import BaseHTTPRequestHandler, HTTPServer
from IPython import get_ipython  # type: ignore
from pygments import highlight
from pygments.styles import get_style_by_name
from pygments.lexers import PythonLexer
from pygments.formatters import TerminalTrueColorFormatter

# formatting stuff

GREEN = "\033[32m"
RED = "\033[31m"
RESET = "\033[0m"
PROMPT = f"{GREEN}❯{RESET} "

style = get_style_by_name("catppuccin-mocha")
formatter = TerminalTrueColorFormatter(style=style)

class IPythonHTTPHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        # run
        content_length = int(self.headers['Content-Length'])
        command = self.rfile.read(content_length).decode('utf-8')
        highlighted_code = highlight(command, PythonLexer(), formatter)
        print(f"{PROMPT}{highlighted_code}", end='')
        ipython = get_ipython()
        result = ipython.run_cell(command)
        print()

        # respond
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        if result.success: self.wfile.write(str(result.result).encode('utf-8'))
        else: self.wfile.write(str(result.error_in_exec).encode('utf-8'))

    def log_message(self, format, *args):
        pass

def start_server():
    try:
        server = HTTPServer(('localhost', 5000), IPythonHTTPHandler)
        server.serve_forever()
    except OSError as ex:
        print(f"{RED}Failed to start remote execution server: {ex}{RESET}\n")

threading.Thread(target=start_server, daemon=True).start()
