#!/bin/bash

update_system() {
	log INFO "Starting system update"

	DEBIAN_FRONTEND=noninteractive apt-get update -y >> "$LOG_FILE" 2>&1
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y >> "$LOG_FILE" 2>&1

	log INFO "System update completed"
}

remove_bloatware() {
	log INFO "Starting bloatware removal"

	for package in "${BLOATWARE_PACKAGES[@]}"
	do
		if dpkg -s "$package" >/dev/null 2>&1;
		then
			DEBIAN_FRONTEND=noninteractive apt-get remove -y "$package" >> "$LOG_FILE" 2>&1
			log INFO "Removed package: $package"
		else
			log WARN "Package already absent: $package"
		fi
	done

	log INFO "Bloatware removal completed"
}

install_security_tools() {
	log INFO "Starting security tools installation"

	for package in "${SECURITY_TOOLS[@]}"
	do
		if dpkg -s "$package" >/dev/null 2>&1;
		then
			log INFO "Package already installed: $package"
		else
			DEBIAN_FRONTEND=noninteractive apt-get install -y "$package" >> "$LOG_FILE" 2>&1
			log INFO "Installed package: $package"
		fi
	done

	log INFO "Security tools installation completed"
}

system_hardening() {
	log INFO "Starting system hardening"

	update_system
	remove_bloatware
	install_security_tools

	log INFO "System hardening completed"
}
