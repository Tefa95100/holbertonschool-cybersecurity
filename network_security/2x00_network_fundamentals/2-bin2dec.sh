#!/bin/bash
[[ $1 =~ ^[0-1]{8}$ ]] && printf "%d\n" "$(echo "ibase=2;$1" | bc)" || echo "Seul un binaire de 8 bits est accepté"
