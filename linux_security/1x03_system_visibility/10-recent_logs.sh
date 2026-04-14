#!/bin/bash
grep "sshd" $1 | awk now=(date %s) limit=(date -d "30 minutes ago" +%s)
