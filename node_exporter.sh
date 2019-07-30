#!/usr/bin/env bash

set -euo pipefail

/usr/bin/stdbuf -i0 -o0 -e0 \
  /usr/local/bin/node_exporter  # TODO: config for node_exporter
