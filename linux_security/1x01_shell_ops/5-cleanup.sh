#!/bin/bash
while read user;
do
	if id $user >/dev/null 2>&1;
	then
		echo "User $user locked"
		usermod -L $user
	else
		echo "User $user not found"
	fi
done < $1
