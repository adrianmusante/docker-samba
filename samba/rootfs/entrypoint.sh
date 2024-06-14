#!/bin/bash
set -eo pipefail
#eval "$(samba-env)"

. /opt/samba/scripts/samba-env.sh

info "Running Samba v${BUILD_TAG} (init)"
debug "USER: $(id)"
debug "HOSTNAME: $(hostname)"

is_debug_enabled && set -x
exec "/opt/samba/scripts/samba.sh" "$@"