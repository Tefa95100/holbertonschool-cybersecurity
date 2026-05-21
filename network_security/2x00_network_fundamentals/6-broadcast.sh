#!/bin/bash
IFS=. read ip1 ip2 ip3 ip4 <<< "$1"; IFS=. read mask1 mask2 mask3 mask4 <<< "$2"; printf "%d.%d.%d.%d\n" $(( (ip1 & mask1) | (mask1 ^ 255) )) $(( (ip2 & mask2) | (mask2 ^ 255) )) $(( (ip3 & mask3) | (mask3 ^ 255) )) $(( (ip4 & mask4) | (mask4 ^ 255) ))
