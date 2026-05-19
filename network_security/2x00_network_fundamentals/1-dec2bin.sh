#!/bin/bash
[[ $1 =~ ^-?[0-9]+$ && $1 -ge 0 && $1 -le 255 ]] && printf "%08d\n" "$(echo "obase=2;$1" | bc)" || echo "Le nombre doit etre un entier compris entre 0 et 255"
