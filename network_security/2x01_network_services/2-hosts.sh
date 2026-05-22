#!/bin/bash
awk '$2=="localhost" && $1 ~ /^[0-9.]+$/ {print $1; exit}' /etc/hosts
