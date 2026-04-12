#!/bin/bash
awk -F: '($3 >= 1000){print $1}' $1 | while read -r user
do
	id -nG "$user" 2>/dev/null | tr ' ' '\n' | grep -E '^(docker|disk|shadow)$' | while read -r group
	do
		echo "$user:$group"
	done
done
