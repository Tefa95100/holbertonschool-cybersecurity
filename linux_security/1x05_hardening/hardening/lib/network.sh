#!/bin/bash

ensure_firewall_dir() {
	mkdir -p "$(dirname "$FILE_FIREWALL")"
	log "Ensured firewall policy directory exists: $(dirname "$FILE_FIREWALL")"
}
write_firewall_rules() {
	ensure_firewall_dir

	local tmp_file
	tmp_file="$(mktemp)"

	{
		echo "DEFAULT_INPUT=deny"
		echo "DEFAULT_OUTPUT=allow"

		for port in "${ALLOWED_PORT[@]}";
		do
			echo "ALLOW_TCP=$port"
		done
	} > "$tmp_file"

	if [ ! -f "$FILE_FIREWALL" ] || ! cmp -s "$tmp_file" "$FILE_FIREWALL";
	then
		mv "$tmp_file" "$FILE_FIREWALL"
		chmod 600 "$FILE_FIREWALL"
		log "Firewall policy written to $FILE_FIREWALL"
	else
		rm -f "$tmp_file"
		log "Firewall policy already compliant"
	fi
}

ensure_sysctl_setting() {
	local key="$1"
	local value="$2"

	if grep -qE "^[[:space:]]*${key}[[:space:]]*=" /etc/sysctl.conf;
	then
		sed -i "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${value}|" /etc/sysctl.conf
		log "Updated sysctl setting: ${key} = ${value}"
	else
		echo "${key} = ${value}" >> /etc/sysctl.conf
		log "Added sysctl setting: ${key} = ${value}"
	fi
}

network_hardening() {
	log "Starting network hardening"

	write_firewall_rules
	ensure_sysctl_setting "net.ipv4.ip_forward" "$STATE_IP_FORWARD"
	ensure_sysctl_setting "net.ipv4.icmp_echo_ignore_all" "$STATE_ICMP_ECHO"

	log "Network hardening completed"
}
