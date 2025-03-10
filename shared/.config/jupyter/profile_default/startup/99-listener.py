import threading
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from IPython import get_ipython
from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import TerminalTrueColorFormatter

# formatting stuff
GREEN = "\033[32m"
RED = "\033[31m"
RESET = "\033[0m"
ipython = get_ipython()
style = ipython.highlighting_style
formatter = TerminalTrueColorFormatter(style=style)
in_prompt = GREEN + ''.join(token[1] for token in ipython.prompts.in_prompt_tokens()) + RESET
cont_prompt = GREEN + ''.join(token[1] for token in ipython.prompts.continuation_prompt_tokens()) + RESET

class IPythonHTTPHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data.decode('utf-8'))
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
        # if result.success: self.wfile.write(str(result.result).encode('utf-8'))
        if result.success: self.wfile.write(json.dumps({"output": result.result, "error": None}).encode('utf-8'))
        else: self.wfile.write(json.dumps({"output": None, "error": result.error_in_exec}).encode('utf-8'))

    def log_message(self, format, *args):
        pass

def start_server():
    try:
        server = HTTPServer(('localhost', 5000), IPythonHTTPHandler)
        server.serve_forever()
    except OSError as ex:
        print(f"{RED}Failed to start remote execution server: {ex}{RESET}\n")

threading.Thread(target=start_server, daemon=True).start()
