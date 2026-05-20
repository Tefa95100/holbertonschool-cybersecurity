#!/bin/bash
[[ $1 =~ ^((25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})$ ]] && IFS=. read a b c d <<< "$1" && printf "%08d.%08d.%08d.%08d\n" "$(echo "obase=2;$a" | bc)" "$(echo "obase=2;$b" | bc)" "$(echo "obase=2;$c" | bc)" "$(echo "obase=2;$d" | bc)" || echo "Seul une adresse ip valide est accepté."
