#!/bin/bash
mkdir -p $1 && chgrp $2 $1 && chmod g+sw,+t $1
