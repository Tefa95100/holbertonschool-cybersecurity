#!/bin/bash
mkdir -p $1 && chown student:$2 $1 && chmod g+sw,+t $1
