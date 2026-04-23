#!/bin/bash

update_system() {
	log "Starting system update"

	DEBIAN_FRONTEND=noninteractive apt-get update -y >> "$LOG_FILE" 2>&1
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y >> "$LOG_FILE" 2>&1

	log "System update completed"
}

remove_bloatware() {
	log "Starting bloatware removal"

	for package in "${BLOATWARE_PACKAGES[@]}"
	do
		if dpkg -s "$package" >/dev/null 2>&1;
		then
			DEBIAN_FRONTEND=noninteractive apt-get remove -y "$package" >> "$LOG_FILE" 2>&1
			log "Removed package: $package"
		else
			log "Package already absent: $package"
		fi
	done

	log "Bloatware removal completed"
}

install_security_tools() {
	log "Starting security tools installation"

	for package in "${SECURITY_TOOLS[@]}"
	do
		if dpkg -s "$package" >/dev/null 2>&1;
		then
			log "Package already installed: $package"
		else
			DEBIAN_FRONTEND=noninteractive apt-get install -y "$package" >> "$LOG_FILE" 2>&1
			log "Installed package: $package"
		fi
	done

	log "Security tools installation completed"
}

apply_system_hardening() {
	log "Starting system hardening"

	update_system
	remove_bloatware
	install_security_tools

	log "System hardening completed"
}
