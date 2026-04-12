#!/bin/bash
awk -F: '($3 >= 1000){print $1}' $1 | while read -r user
do
	for group in docker disk shadow
	do
		grep -E "^$group:[^:]*:[^:]*:([^,]*,)*$user(,|$)" /etc/group >/dev/null && echo "$user:$group"
	done
done
