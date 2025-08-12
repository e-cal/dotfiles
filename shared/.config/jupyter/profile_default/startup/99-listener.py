import io
import json
import threading
from contextlib import redirect_stderr, redirect_stdout
from http.server import BaseHTTPRequestHandler, HTTPServer
from IPython import get_ipython  # type: ignore
from pygments import highlight
from pygments.formatters import TerminalTrueColorFormatter
from pygments.lexers import PythonLexer

# formatting stuff
GREEN = "\033[32m"
RED = "\033[31m"
RESET = "\033[0m"
ipython = get_ipython()
assert ipython is not None, "D:"
# Use the new theme system - IPython 9.0+ uses 'colors' instead of 'highlighting_style'
# We'll use catppuccin-mocha for the pygments formatter
try:
    formatter = TerminalTrueColorFormatter(style='catppuccin-mocha')
except:
    # Fallback to default if catppuccin-mocha is not available
    formatter = TerminalTrueColorFormatter(style='default')
in_prompt = GREEN + ''.join(token[1] for token in ipython.prompts.in_prompt_tokens()) + RESET  # type: ignore
cont_prompt = GREEN + ''.join(token[1] for token in ipython.prompts.continuation_prompt_tokens()) + RESET  # type: ignore

class IPythonHTTPHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            assert ipython is not None, "D:"
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))
        except Exception as e: 
            return self.data_error(e)

        code = '\n'.join(data.get('code', []))
        syntax = highlight(code, PythonLexer(), formatter)
        lines = syntax.rstrip().split("\n")
        display = f"{in_prompt}{lines[0]}"
        for line in lines[1:]:
            display += f"\n{cont_prompt}{line}"
        print(f"{display}")
        stdout_capture, stderr_capture = io.StringIO(), io.StringIO()
        with redirect_stdout(stdout_capture), redirect_stderr(stderr_capture):
            result = ipython.run_cell(code)
        stdout, stderr = stdout_capture.getvalue(), stderr_capture.getvalue()
        print(stdout)
        print()

        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        if result.success: self.wfile.write(json.dumps({
            "result": result.result,
            "error": None,
            "stdout": stdout,
            "stderr": stderr,
        }).encode('utf-8'))
        else:
            err_obj = result.error_in_exec if result.error_in_exec is not None else result.error_before_exec
            err_msg = f"{err_obj.__class__.__name__}: {err_obj.args[0]}"  # type: ignore
            self.wfile.write(json.dumps({
                "result": None,
                "error": err_msg,
                "stdout": stdout,
                "stderr": stderr,
            }).encode('utf-8'))

    def data_error(self, e):
        self.send_response(400)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(json.dumps({
            "result": None,
            "error": f"Bad request: {e}",
            "stdout": None,
            "stderr": None,
        }).encode('utf-8'))

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
