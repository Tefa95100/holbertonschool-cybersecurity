#!/bin/bash
ss -lnt4 | awk -F: 'NR>1 {print $1}' | sort -n | uniq
