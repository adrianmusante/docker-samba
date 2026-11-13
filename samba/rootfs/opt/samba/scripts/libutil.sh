#!/bin/bash

is_boolean_yes() { grep -i -qE '^(1|true|yes)$' <(echo -n "${1-}") ; }
is_boolean_no() { grep -i -qE '^(0|false|no)$' <(echo -n "${1-}") ; }
is_boolean() { is_boolean_yes "${1-}" || is_boolean_no "${1-}" ; }

# Fail if value is set to something other than a recognized boolean.
# Empty or unset is allowed (caller treats it as the default / off).
require_boolean() {
  local name="$1" value="${2-}"
  [[ -z "$value" ]] && return 0
  is_boolean "$value" || do_error "Invalid boolean for ${name}: '${value}' (expected 1|true|yes|0|false|no)"
}

is_debug_enabled() { is_boolean_yes "${SAMBA_DEBUG:-false}" ; }

if is_boolean_yes "${SAMBA_LOG_COLOR:-true}" ; then
  GREEN='\033[38;5;2m'
  MAGENTA='\033[38;5;5m'
  RED='\033[38;5;1m'
  RESET='\033[0m'
  YELLOW='\033[38;5;3m'
fi

log() { printf "%b\\n" "${MAGENTA}$(date "+%T.%2N")${RESET} ${*}" >&2;}
info() { log "${GREEN:-}INF0 ${RESET:-} ==> ${*}"; }
warn() { log "${YELLOW:-}WARN ${RESET:-} ==> ${*}" ; }
error() { log "${RED:-}ERROR${RESET:-} ==> ${*}" ; }
debug() {
  if is_debug_enabled; then
    log "${MAGENTA:-}DEBUG${RESET:-} ==> ${*}"
  fi
}

do_success() { info "$@"; exit 0; }
do_error() { error "$@"; exit 1; }
