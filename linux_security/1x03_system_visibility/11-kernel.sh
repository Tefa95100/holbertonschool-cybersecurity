#!/bin/bash
test -e $1 && grep "segfault" $1
