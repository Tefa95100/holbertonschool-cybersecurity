#!/bin/bash

ensure_login_defs_setting() {
	local key="$1"
	local value="$2"
	local file="/etc/login.defs"

	if grep -qE "^[[:space:]]*${key}[[:space:]]+" "$file"; then
		sed -i "s|^[[:space:]]*${key}[[:space:]].*|${key} ${value}|" "$file"
		log INFO "Updated ${key} in ${file}"
	else
		echo "${key} ${value}" >> "$file"
		log INFO "Added ${key} in ${file}"
	fi
}

ensure_pam_module_line() {
	local file="$1"
	local module="$2"
	local line="$3"

	if grep -qE "^[[:space:]]*#?[[:space:]]*.*${module}" "$file"; then
		sed -i "s|^[[:space:]]*#\?[[:space:]]*.*${module}.*|${line}|" "$file"
		log INFO "Updated PAM module ${module} in ${file}"

	elif grep -q "pam_deny.so" "$file"; then
		sed -i "/pam_deny.so/i ${line}" "$file"
		log INFO "Added PAM module ${module} before pam_deny.so in ${file}"

	elif grep -q "pam_permit.so" "$file"; then
		sed -i "/pam_permit.so/i ${line}" "$file"
		log INFO "Added PAM module ${module} before pam_permit.so in ${file}"

	else
		echo "$line" >> "$file"
		log INFO "Added PAM module ${module} at end of ${file}"
	fi
}

set_password_policy() {
	log INFO "Starting password policy hardening"

	ensure_login_defs_setting "PASS_MAX_DAYS" "$PASS_MAX_DAYS"
	ensure_login_defs_setting "PASS_MIN_LEN" "$PASS_MIN_LEN"

	ensure_pam_module_line \
		"/etc/pam.d/common-password" \
		"pam_pwquality.so" \
		"password requisite pam_pwquality.so retry=3 minlen=${PASS_MIN_LEN} ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1"

	log INFO "Password policy hardening completed"
}

set_faillock_policy() {
	log INFO "Starting faillock hardening"

	ensure_pam_module_line \
		"/etc/pam.d/common-auth" \
		"pam_faillock.so preauth" \
		"auth required pam_faillock.so preauth silent deny=${FAIL_LOCK_ATTEMPTS} unlock_time=900"

	ensure_pam_module_line \
		"/etc/pam.d/common-auth" \
		"pam_faillock.so authfail" \
		"auth [default=die] pam_faillock.so authfail deny=${FAIL_LOCK_ATTEMPTS} unlock_time=900"

	ensure_pam_module_line \
		"/etc/pam.d/common-account" \
		"pam_faillock.so" \
		"account required pam_faillock.so"

	log INFO "Faillock hardening completed"
}

cleanup_users() {
	local user uid groups primary_group

	log INFO "Starting cleanup of non-privileged users with UID > 1000"

	while IFS=: read -r user _ uid _ _ _ _
	do
		if [ "$uid" -le 1000 ]; then
			continue
		fi

		if [ "$user" = "nobody" ]; then
			continue
		fi

		if id -nG "$user" 2>/dev/null | grep -qwE "sudo|wheel"; then
			log INFO "Kept privileged user: $user"
			continue
		fi

		userdel -r "$user" >/dev/null 2>&1 || true
		log INFO "Deleted user with UID > 1000 and no sudo/wheel membership: $user"

	done < /etc/passwd

	log INFO "User cleanup completed"
}

lock_root_account() {
	local root_status

	root_status="$(passwd -S root 2>/dev/null | awk '{print $2}')"

	if [ "$root_status" = "L" ]; then
		log INFO "Root account password already locked"
	else
		passwd -l root >/dev/null 2>&1
		log INFO "Root account password locked"
	fi
}

identity_hardening() {
	log INFO "Starting identity hardening"

	set_password_policy
	set_faillock_policy
	lock_root_account
	cleanup_users

	log INFO "Identity hardening completed"
}
