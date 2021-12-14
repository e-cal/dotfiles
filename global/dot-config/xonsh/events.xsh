@events.on_post_rc
def print_triangles(*_, **__):
    clear
    print("")

@events.autovox_policy
def dotvenv_policy(path, **_):
    venv = path / '.venv'
    if venv.exists():
        with venv.open('r') as f:
            env_name = f.readline().strip()
            return $VIRTUALENV_HOME+f"/{env_name}"
