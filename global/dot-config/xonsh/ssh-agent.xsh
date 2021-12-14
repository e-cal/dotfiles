from pathlib import Path


_SSH_AGENT_ENV=Path($XDG_RUNTIME_DIR + "/ssh-agent.env")

def _new_agent():
    _SSH_AGENT_ENV.write_text($(ssh-agent -s))
    source-bash @(_SSH_AGENT_ENV)
    ssh-add ~/.ssh/coeus_id_ed25519


if not $(pgrep -u $USER ssh-agent):
    #echo "starting ssh-agent"
    #echo "ssh-add ~/.ssh/keys (not .pub)"
    _new_agent()
else:
  if _SSH_AGENT_ENV.exists():
      #echo "sourcing running ssh-agent"
      source-bash @(_SSH_AGENT_ENV)
  else:
      #echo "ssh-agent is running but _SSH_AGENT_ENV not found."
      #echo "killall ssh-agent"
      killall ssh-agent
      sleep 1
      _new_agent()

