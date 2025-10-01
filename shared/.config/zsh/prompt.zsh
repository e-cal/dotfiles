# Load prompt
eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
#                     Custom Command Duration Component
# ------------------------------------------------------------------------------

# Measure last command duration for transient prompt
zmodload zsh/datetime 2>/dev/null || true

# Storage for last command duration
typeset -gF 6 _TRANSIENT_LAST_CMD_S=0
typeset -gF 6 _TRANSIENT_LAST_CMD_MS=0
typeset -g _TRANSIENT_LAST_CMD_STR=""

# Tuning knobs
typeset -g TRANSIENT_CMD_DURATION_MIN_MS=${TRANSIENT_CMD_DURATION_MIN_MS:-1000}
typeset -g TRANSIENT_CMD_DURATION_PREFIX=${TRANSIENT_CMD_DURATION_PREFIX:-"󱦟 "}
typeset -g TRANSIENT_CMD_DURATION_STYLE=${TRANSIENT_CMD_DURATION_STYLE:-"%F{8}"}

# Format duration in whole units (d, h, m, s), no fractions
function _transient__format_duration_ms() {
  local -F 6 ms=$1
  local -F 6 s=$(( ms / 1000.0 ))
  if (( ms < TRANSIENT_CMD_DURATION_MIN_MS )); then
    print -r -- ""
    return
  fi
  local -i total=${s%.*}
  local -i d=$(( total/86400 ))
  local -i h=$(( (total%86400)/3600 ))
  local -i m=$(( (total%3600)/60 ))
  local -i sec=$(( total%60 ))
  local out=""
  (( d )) && out+="${d}d"
  (( h )) && out+="${h}h"
  (( m )) && out+="${m}m"
  out+="${sec}s"
  print -r -- "$out
‎
"
}

function _transient_preexec_timer() {
  typeset -gF 6 _TRANSIENT_CMD_START=$EPOCHREALTIME
}

function _transient_precmd_timer() {
  if [[ -n "${_TRANSIENT_CMD_START-}" ]]; then
    local -F 6 end=$EPOCHREALTIME
    local -F 6 dur=$(( end - _TRANSIENT_CMD_START ))
    _TRANSIENT_LAST_CMD_S=$dur
    _TRANSIENT_LAST_CMD_MS=$(( dur * 1000.0 ))
    _TRANSIENT_LAST_CMD_STR=$(_transient__format_duration_ms $_TRANSIENT_LAST_CMD_MS)
    unset _TRANSIENT_CMD_START
  else
    _TRANSIENT_LAST_CMD_STR=""
  fi
}

(( ${+preexec_functions} )) || typeset -ga preexec_functions
preexec_functions+=_transient_preexec_timer
(( ${+precmd_functions} )) || typeset -ga precmd_functions
precmd_functions+=_transient_precmd_timer

function _transient_print_cmd_duration() {
  if [[ -n "$_TRANSIENT_LAST_CMD_STR" ]]; then
    local out
    out="${TRANSIENT_CMD_DURATION_STYLE}${TRANSIENT_CMD_DURATION_PREFIX}${_TRANSIENT_LAST_CMD_STR}%f"
    printf "%s\n\n\n\n" "$out"
  fi
}

TRANSIENT_PROMPT_TRANSIENT_PROMPT='
$(_transient_print_cmd_duration)$(starship module time)
$(starship module directory)$(starship module git_branch)
$(starship module character)'


# ------------------------------------------------------------------------------
#                           Transient Promt Plugin
# ------------------------------------------------------------------------------

typeset -g TRANSIENT_PROMPT_PROMPT=${TRANSIENT_PROMPT_PROMPT-$PROMPT}
typeset -g TRANSIENT_PROMPT_RPROMPT=${TRANSIENT_PROMPT_RPROMPT-$RPROMPT}
typeset -g TRANSIENT_PROMPT_TRANSIENT_PROMPT=${TRANSIENT_PROMPT_TRANSIENT_PROMPT-$TRANSIENT_PROMPT_PROMPT}
typeset -g TRANSIENT_PROMPT_TRANSIENT_RPROMPT=${TRANSIENT_PROMPT_TRANSIENT_RPROMPT-$TRANSIENT_PROMPT_RPROMPT}
typeset -gA TRANSIENT_PROMPT_ENV

typeset -g TRANSIENT_PROMPT_VERSION=1.0.1

if ! [[ $(whence TRANSIENT_PROMPT_PRETRANSIENT) ]]; then
  function TRANSIENT_PROMPT_PRETRANSIENT() { true }
fi

function _transient_prompt_init() {
  [[ -c /dev/null ]] || return
  zmodload zsh/system || return

  _transient_prompt_toggle_transient 0

  zle -N send-break _transient_prompt_widget-send-break

  zle -N zle-line-finish _transient_prompt_widget-zle-line-finish

  (( ${+precmd_functions} )) || typeset -ga precmd_functions
  (( ${#precmd_functions} )) || {
    do_nothing() {
      true
    }

    precmd_functions=( do_nothing )
  }

  precmd_functions+=_transient_prompt_precmd
}

function _transient_prompt_precmd() {
  TRAPINT() {
    zle && _transient_prompt_widget-zle-line-finish
    return $(( 128 + $1 ))
  }
}

function _transient_prompt_restore_prompt() {
  exec {1}>&-
  (( ${+1} )) && zle -F $1
  _transient_prompt_fd=0
  _transient_prompt_toggle_transient 0
  zle reset-prompt
  zle -R
}

function _transient_prompt_toggle_transient() {
  local -i transient
  transient=${1-0}

  if (( transient )); then
    PROMPT=$TRANSIENT_PROMPT_TRANSIENT_PROMPT
    RPROMPT=$TRANSIENT_PROMPT_TRANSIENT_RPROMPT

    return
  fi

  PROMPT=$TRANSIENT_PROMPT_PROMPT
  RPROMPT=$TRANSIENT_PROMPT_RPROMPT
}

function _transient_prompt_widget-send-break() {
  _transient_prompt_widget-zle-line-finish
  zle .send-break
}

function _transient_prompt_widget-zle-line-finish() {
  local key
  local value

  (( ! _transient_prompt_fd )) && {
    sysopen -r -o cloexec -u _transient_prompt_fd /dev/null
    zle -F $_transient_prompt_fd _transient_prompt_restore_prompt
  }

  # cannot use `for key value in ${(kv)…}` because that has undesired results when values are empty
  for key in ${(k)TRANSIENT_PROMPT_ENV}; do
    value=$TRANSIENT_PROMPT_ENV[$key]

    # back up context
    typeset -g _transient_prompt_${key}_saved=${(P)key}

    # apply transient prompt context
    typeset -g "$key"="$value"
  done

  TRANSIENT_PROMPT_PRETRANSIENT
  _transient_prompt_toggle_transient 1

  zle && zle reset-prompt && zle -R

  # restore backed up context
  local key_saved
  for key in ${(k)TRANSIENT_PROMPT_ENV}; do
    typeset key_saved=_transient_prompt_${key}_saved
    typeset -g $key=${(P)key_saved}
    unset $key_saved
  done
}
_transient_prompt_init
unfunction -m _transient_prompt_init
