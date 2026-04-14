#!/bin/bash
test -e $1 && grep -i segfault $1
