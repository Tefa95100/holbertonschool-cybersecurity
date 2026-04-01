#!/bin/bash
mkdir -p $1 && chown :$2 $1 && chmod g+sw,+t $1
