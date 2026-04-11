#!/bin/bash
awk -F: '($3 > 1000){print $1}' $1 | while read user
do
	groups=$(id -nG "$user")
	for group in $groups
	do
		if [ "$group" = "disk" ] || [ "$group" = "docker" ] || [ "$group" = "shadow" ]
		then
			echo "$user:$group"
		fi
	done
done
