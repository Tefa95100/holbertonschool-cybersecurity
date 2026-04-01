#!/bin/bash
find $1 -perm -4000 -type f -mtime -7 -size +1M ! -name '*.gz' 2>/dev/null
