#!/bin/bash

is_boolean_yes() { grep -i -qE '^(1|true|yes)$' <(echo -n "${1-}") ; }
is_debug_enabled() { is_boolean_yes "${SAMBA_DEBUG:-false}" ; }

if is_boolean_yes "${SAMBA_LOG_COLOR:-true}" ; then
  GREEN='\033[38;5;2m'
  MAGENTA='\033[38;5;5m'
  RED='\033[38;5;1m'
  RESET='\033[0m'
  YELLOW='\033[38;5;3m'
fi

stderr_print() { printf "%b\\n" "${*}" >&2 ; }
log() { stderr_print "${MAGENTA:-}$(date "+%T.%2N ")${RESET:-}${*}" ; }
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
