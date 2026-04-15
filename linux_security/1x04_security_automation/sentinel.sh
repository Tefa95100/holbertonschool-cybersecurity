#!/bin/bash
if [ ! -f ./sentinel.conf ];
then
	exit 1
fi
if [ -z "$SERVICES" ] || [ -z "$FILES_TO_WATCH" ];
then
	exit 1
fi
