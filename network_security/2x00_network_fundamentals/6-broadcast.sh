#!/bin/bash 
IFS=. read ip1 ip2 ip3 ip4 <<< "$1"; IFS=. read mask1 mask2 mask3 mask4 <<< "$2"; printf "%d.%d.%d.%d\n"
