#!/usr/bin/env bash
##
## This script is based on:
##   https://gist.github.com/tomazzaman/63265dfab3a9a61781993212fa1057cb
##
set -euo pipefail

printf "READY\n"

while read line; do
  echo "Processing Event: ${line}" >&2;
  kill -SIGQUIT ${PPID}
done < /dev/stdin
