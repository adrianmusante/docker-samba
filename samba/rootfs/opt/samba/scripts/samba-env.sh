#!/bin/sh

. "/opt/samba/scripts/libutil.sh"

export SAMBA_DEBUG="${SAMBA_DEBUG:-false}"
export SAMBA_LOG_LEVEL="${SAMBA_LOG_LEVEL:-"$(is_debug_enabled && echo 3 || echo 0)"}"

require_boolean SAMBA_DEBUG "${SAMBA_DEBUG}"
require_boolean SAMBA_LOG_COLOR "${SAMBA_LOG_COLOR:-}"
require_boolean SAMBA_NMBD "${SAMBA_NMBD:-}"
require_boolean SAMBA_PERMISSIONS "${SAMBA_PERMISSIONS:-}"
require_boolean SAMBA_RECYCLE "${SAMBA_RECYCLE:-}"
require_boolean SAMBA_SMB "${SAMBA_SMB:-}"
require_boolean SAMBA_WIDELINKS "${SAMBA_WIDELINKS:-}"
