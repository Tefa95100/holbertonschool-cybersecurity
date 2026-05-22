#!/bin/bash
awk '$2=="localhost" && $1 ~ /^[0-9.]+$/ {printf "%s",$1; exit}' /etc/hosts
