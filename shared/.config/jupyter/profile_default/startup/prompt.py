from IPython.terminal.prompts import Prompts, Token

class MyPrompt(Prompts):
    def in_prompt_tokens(self, cli=None):
        return [ ( Token.Prompt, "❯ ",), ]

    def out_prompt_tokens(self, cli=None):
        return []

ip = get_ipython()
ip.prompts = MyPrompt(ip)
