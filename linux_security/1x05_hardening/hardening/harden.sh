#!/bin/bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/config/harden.cfg"
source "$BASE_DIR/lib/network.sh"
source "$BASE_DIR/lib/ssh.sh"
source "$BASE_DIR/lib/identity.sh"
source "$BASE_DIR/lib/system.sh"

INFO_MESSAGES=()
WARN_MESSAGES=()
ERROR_MESSAGES=()

log() {
	local level="$1"
	shift
	local message="$*"

	echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"

	case "$level" in
		INFO) INFO_MESSAGES+=("$message") ;;
		WARN) WARN_MESSAGES+=("$message") ;;
		ERROR) ERROR_MESSAGES+=("$message") ;;
	esac
}

generate_audit_report() {
	local status="PASS"

	if [ "${#ERROR_MESSAGES[@]}" -gt 0 ]; then
		status="FAIL"
	fi

	{
		echo "==============================================="
		echo " HARDENING AUDIT REPORT - $(date '+%Y-%m-%d %H:%M:%S')"
		echo "==============================================="
		echo

		echo "[INFO] Hardening procedure completed."
		echo "[INFO] SSH configured using: ${SSH_SETTINGS[*]}"
		echo "[INFO] Firewall policy file: $FILE_FIREWALL"
		echo "[INFO] Firewall allowed ports: ${ALLOWED_PORT[*]}"
		echo "[INFO] Kernel hardening: ip_forward=$STATE_IP_FORWARD, icmp_echo_ignore_all=$STATE_ICMP_ECHO"
		echo "[INFO] Password policy: min length=$PASS_MIN_LEN, max age=$PASS_MAX_DAYS days"
		echo "[INFO] Lockout policy: $FAIL_LOCK_ATTEMPTS failed attempts"
		echo "[INFO] Security tools expected: ${SECURITY_TOOLS[*]}"
		echo "[INFO] Bloatware expected removed: ${BLOATWARE_PACKAGES[*]}"

		echo

		if [ "${#WARN_MESSAGES[@]}" -gt 0 ]; then
			for warning in "${WARN_MESSAGES[@]}"; do
				echo "[WARN] $warning"
			done
			echo
		fi

		if [ "${#ERROR_MESSAGES[@]}" -gt 0 ]; then
			for error in "${ERROR_MESSAGES[@]}"; do
				echo "[ERROR] $error"
			done
			echo
		fi

		echo "==============================================="
		echo " COMPLIANCE STATUS: $status"
		echo "==============================================="
	} > "$REPORT_FILE"

	log INFO "Audit report generated: $REPORT_FILE"
}

if [ "$(id -u)" -ne 0 ];
then
	log ERROR "Script was not run as root"
	echo "Permission denied: run as root." >&2
	exit 1
fi

log INFO "Hardening framework initialized"

main() {
	log INFO "Starting hardening process"

	network_hardening
	parameters_ssh
	identity_hardening
	system_hardening

	log INFO "Hardening process completed"

	generate_audit_report
}

main "$@"
