#!/bin/bash
grep -m 1 -w "localhost" /etc/hosts | grep -E '^[0-9]' | awk '{print $1}'
