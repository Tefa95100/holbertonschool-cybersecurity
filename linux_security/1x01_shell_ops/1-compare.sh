#!/bin/bash
diff <(cut -d ":" -f 1 $1) <(cut -d ":" -f 1 $1 | sort -d)
