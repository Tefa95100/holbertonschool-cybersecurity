#!/bin/bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ];
then
	echo "Permission denied: run as root."
	exit 1
fi

source ./config/harden.cfg
source ./lib/network.sh
source ./lib/ssh.sh
source ./lib/identity.sh
source ./lib/system.sh

log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}
log "Hardening framework initialized"

main() {
	log "Starting hardening process"

	network_hardening
	parameters_ssh
	identity_hardening
	system_hardening

	log "Hardening process completed"
}

main "$@"
