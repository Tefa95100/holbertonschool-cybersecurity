#!/bin/bash
ls -l $1 | awk '{if ($5 > 1024) print $9}'
