#!/bin/bash
grep -w "localhost" /etc/hosts | grep -E '^[0-9]' | awk '{print $1; exit}'
