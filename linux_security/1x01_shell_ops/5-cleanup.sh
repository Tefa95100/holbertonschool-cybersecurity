#!/bin/bash
while read user
do
	id $user
done $1
