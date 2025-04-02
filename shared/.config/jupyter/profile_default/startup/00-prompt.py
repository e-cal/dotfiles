from IPython.terminal.prompts import Prompts, Token  # type: ignore

class MyPrompt(Prompts):
    def in_prompt_tokens(self, cli=None):
        return [ ( Token.Prompt, "❯ ",), ]  # noqa: RUF001

    def continuation_prompt_tokens(self, width=None):
        return [(Token.Prompt, '| ')]

    def out_prompt_tokens(self, cli=None):
        return []

ip = get_ipython()  # noqa: F821
ip.prompts = MyPrompt(ip)
