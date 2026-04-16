#!/bin/bash
FILE="./sentinel.conf"
if [ ! -f "$FILE" ];
then
	exit 1
fi
source "$FILE"
if [ -z "${SERVICES+x}" ] || [ -z "${FILES_TO_WATCH+x}" ] || [ -z "${ALLOWED_PORTS+x}" ];
then
	exit 1
fi

check_services() {
	for svc in "${SERVICES[@]}";
	do
		if pgrep -f "$svc" > /dev/null;
		then
			echo "OK: $svc is running"
		else
			if eval "$svc" > /dev/null;
			then
				echo "FIXED: Restarted $svc"
			else
				echo "ERROR: Failed to restart $svc"
			fi
		fi
	done 
}

check_integrity() {
	for file in "${FILES_TO_WATCH[@]}";
	do
		current_hash=$(md5sum "$file" | awk '{print $1}')
		gold_hash=$(md5sum /var/backups/sentinel/"$(basename "$file")".gold | awk '{print $1}')
		if [ "$current_hash" == "$gold_hash" ];
		then
			echo "OK: $(basename "$file") integrity verified"
		else
			cp /var/backups/sentinel/"$(basename "$file")".gold "$file"
			echo "FIXED: Restored $(basename "$file")"
		fi
	done
}

check_ports() {
	ss -tlnp | tail -n +2 | while read -r line;
	do
		port=$(echo "$line" | awk '{print $4}' | awk -F: '{print $NF}')
		pid=$(echo "$line" | grep -o 'pid=[0-9]*' | cut -d= -f2)

		allowed=false

		for allowed_port in "${ALLOWED_PORTS[@]}";
		do
			if [ "$port" == "$allowed_port" ];
			then
				allowed=true
				break
			fi
		done
		if [ "$allowed" == false ] && [ -n "$pid"  ];
		then
			kill "$pid" 2>/dev/null
			echo "ALERT: Killed rogue process on port $port"
		fi
	done
}

check_services
check_integrity
check_ports
