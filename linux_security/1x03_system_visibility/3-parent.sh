#!/bin/bash
ps -p $1 -o ppid | awk 'NR==2 {print $1}'
