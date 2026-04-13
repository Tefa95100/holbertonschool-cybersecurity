#!/bin/bash
ss -lnt4 | awk -F: '/LISTEN/ {print $1}' | sort -n | uniq
