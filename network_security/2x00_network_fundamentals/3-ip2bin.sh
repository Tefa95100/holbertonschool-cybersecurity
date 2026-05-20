#!/bin/bash
[[ $1 =~ ^((25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})$ ]] && printf "%08d\n" "$(echo "obase=2;$1" | bc)" || echo "Seul une adresse ip valide est accepté."
