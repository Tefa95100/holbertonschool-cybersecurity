#!/bin/bash

parameters_ssh() {
	log INFO "Starting SSH hardening"

	for parameter in "${SSH_SETTINGS[@]}";
	do
		if grep -q "${parameter%% *}" "$FILE_SSHD";
		then
			sed -i "/${parameter%% *}/c\${parameter}" "$FILE_SSHD"
			log INFO "Updated SSH setting: $parameter"
		else
			echo "$parameter" >> "$FILE_SSHD"
			log INFO "Added SSH setting $parameter"
		fi
	done

	log INFO "SSH hardening completed"
}
