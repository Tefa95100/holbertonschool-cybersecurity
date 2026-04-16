#!/bin/bash
FILE="./sentinel.conf"
if [ ! -f "$FILE" ];
then
	exit 1
fi
source "$FILE"
if [ -z "${SERVICES+x}" ] || [ -z "${FILES_TO_WATCH+x}" ];
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

check_services
