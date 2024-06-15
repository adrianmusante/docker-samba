#!/bin/sh

. "/opt/samba/scripts/libutil.sh"

export SAMBA_DEBUG="${SAMBA_DEBUG:-false}"
export SAMBA_LOG_LEVEL="${SAMBA_LOG_LEVEL:-"$(is_debug_enabled && echo 3 || echo 0)"}"

