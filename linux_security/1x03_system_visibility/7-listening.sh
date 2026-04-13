#!/bin/bash
ss -tl4 | awk -F: '/LISTEN/ {print $1}' | sort -n | uniq
