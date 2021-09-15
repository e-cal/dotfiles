@events.on_ptk_create
def alt_right_fill_word_suggestion(bindings, **kw):
    import re
    from prompt_toolkit.application.current import get_app
    from prompt_toolkit.filters import Condition

    @Condition
    def suggestion_available():
        app = get_app()
        return (
            app.current_buffer.suggestion is not None and app.current_buffer.suggestion.text
            and app.current_buffer.document.is_cursor_at_the_end
        )

    @bindings.add("escape", "right", filter=suggestion_available)
    def _accept(event):
        """
        Accept suggestion.
        """
        b = event.current_buffer

        b.insert_text(b.suggestion.text)

    @bindings.add("right", filter=suggestion_available)
    def _fill(event):
        """
        Fill partial suggestion.
        """
        b = event.current_buffer

        t = re.split(r"([^\s/]+[\s/]+)", b.suggestion.text)
        b.insert_text(next(x for x in t if x))
