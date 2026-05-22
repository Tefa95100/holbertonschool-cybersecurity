#!/bin/bash
echo $(( $(traceroute $1 | wc -l) - 1 ))
