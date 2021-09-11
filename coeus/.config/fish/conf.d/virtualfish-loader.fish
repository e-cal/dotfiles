set -g VIRTUALFISH_VERSION 2.5.1
set -g VIRTUALFISH_PYTHON_EXEC /usr/bin/python
source /usr/lib/python3.9/site-packages/virtualfish/virtual.fish
source /usr/lib/python3.9/site-packages/virtualfish/global_requirements.fish
source /usr/lib/python3.9/site-packages/virtualfish/environment.fish
source /usr/lib/python3.9/site-packages/virtualfish/projects.fish
source /usr/lib/python3.9/site-packages/virtualfish/auto_activation.fish
emit virtualfish_did_setup_plugins