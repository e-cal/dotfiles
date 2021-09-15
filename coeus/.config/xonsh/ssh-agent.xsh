from pathlib import Path

_SSH_AGENT_ENV=Path($XDG_RUNTIME_DIR + "/ssh-agent.env")
if not $(pgrep -u $USER ssh-agent):
    echo "starting ssh-agent"
    _SSH_AGENT_ENV.write_text($(ssh-agent -s))
    source-bash @(_SSH_AGENT_ENV)
    ssh-add ~/.ssh/coeus_id_ed25519
    echo "ssh-add ~/.ssh/keys (not .pub)"
else:
  if _SSH_AGENT_ENV.exists():
      echo "sourcing running ssh-agent"
      source-bash @(_SSH_AGENT_ENV)
  else:
      echo "ssh-agent is running but _SSH_AGENT_ENV not found."
      echo "killall ssh-agent"
