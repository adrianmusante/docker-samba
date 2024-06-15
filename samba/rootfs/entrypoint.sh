#!/bin/bash
set -eo pipefail
eval "$(samba-env)"

info "Running Samba with build version: ${BUILD_TAG}"
debug "USER: $(id)"
debug "HOSTNAME: $(hostname)"

is_debug_enabled && set -x
exec samba "$@"
