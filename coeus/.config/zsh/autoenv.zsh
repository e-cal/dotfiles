function _virtualenv_auto_activate() {
    if [[ -f ".venv" ]]; then
        _VENV_PATH=$VIRTUALENV_HOME/$(cat .venv)

        if [[ "$VIRTUAL_ENV" != $_VENV_PATH ]]; then
            source $_VENV_PATH/bin/activate
        fi

    elif (( ${+VIRTUAL_ENV} )); then
        deactivate
    fi
}

function venvconnect (){
    if [[ -n $VIRTUAL_ENV ]]; then
        echo $(basename $VIRTUAL_ENV) > .venv
    else
        echo "Activate a virtualenv first"
    fi
}

chpwd_functions+=(_virtualenv_auto_activate)
precmd_functions=(_virtualenv_auto_activate $precmd_functions)
