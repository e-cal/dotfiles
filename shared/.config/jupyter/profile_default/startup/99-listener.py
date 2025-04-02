import threading
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from IPython import get_ipython  # type: ignore
from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import TerminalTrueColorFormatter

# formatting stuff
GREEN = "\033[32m"
RED = "\033[31m"
RESET = "\033[0m"
ipython = get_ipython()
assert ipython is not None, "D:"
style = ipython.highlighting_style  # type: ignore
formatter = TerminalTrueColorFormatter(style=style)
in_prompt = GREEN + ''.join(token[1] for token in ipython.prompts.in_prompt_tokens()) + RESET  # type: ignore
cont_prompt = GREEN + ''.join(token[1] for token in ipython.prompts.continuation_prompt_tokens()) + RESET  # type: ignore

a = 1

class IPythonHTTPHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data.decode('utf-8'))
        if isinstance(data, list): return self.data_error()
        code = '\n'.join(data.get('code', []))
        syntax = highlight(code, PythonLexer(), formatter)
        lines = syntax.rstrip().split("\n")
        display = f"{in_prompt}{lines[0]}"
        for line in lines[1:]:
            display += f"\n{cont_prompt}{line}"
        print(f"{display}")
        result = ipython.run_cell(code)
        print()

        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        if result.success: self.wfile.write(json.dumps({"output": result.result, "error": None}).encode('utf-8'))
        else:
            err_obj = result.error_in_exec if result.error_in_exec is not None else result.error_before_exec
            err_msg = f"{err_obj.__class__.__name__}: {err_obj.args[0]}"  # type: ignore
            self.wfile.write(json.dumps({"output": None, "error": err_msg}).encode('utf-8'))

    def data_error(self):
        self.send_response(400)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(json.dumps({"output": None, "error": "Invalid data format. Expected a dictionary, got a list."}).encode('utf-8'))

    def log_message(self, format, *args):
        pass

def start_server():
    try:
        server = HTTPServer(('localhost', 5000), IPythonHTTPHandler)
        print(f"{GREEN}Remote execution server started successfully on port 5000{RESET}\n")
        server.serve_forever()
    except OSError as ex:
        print(f"{RED}Failed to start remote execution server: {ex}{RESET}\n")

threading.Thread(target=start_server, daemon=True).start()
