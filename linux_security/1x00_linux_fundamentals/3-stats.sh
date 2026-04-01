#!/bin/bash
ls -l $1 | awk '{print $3}' | uniq -cd | sort -nr | head -n 1
