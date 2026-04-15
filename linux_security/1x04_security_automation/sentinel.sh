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
