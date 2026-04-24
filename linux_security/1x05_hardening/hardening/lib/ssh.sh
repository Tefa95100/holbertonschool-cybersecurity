#!/bin/bash

parameters_ssh() {
	for parameter in "${SSH_SETTINGS[@]}";
	do
		if grep -q "${parameter%% *}" "$FILE_SSHD";
		then
			sed -i "/${parameter%% *}/c\${parameter}" "$FILE_SSHD"
			log "Updated SSH setting: $parameter"
		else
			echo "$parameter" >> "$FILE_SSHD"
			log "Added SSH setting $parameter"
		fi
	done
}
