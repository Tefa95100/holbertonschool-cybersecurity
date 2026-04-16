#!/bin/bash
grep "sshd" $1 | awk -v now=(date %s) -v limit=(date -d "30 minutes ago" +%s)
