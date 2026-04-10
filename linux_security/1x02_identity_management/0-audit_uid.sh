#!/bin/bash
awk -F: '{if ($3 == 0 && $1 != "root") print $1}' $1
