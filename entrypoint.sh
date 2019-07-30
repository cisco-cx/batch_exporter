#!/bin/bash
set -xeuo pipefail

export SUPERVISORCONFIG=${SUPERVISORCONFIG:-/etc/supervisor/supervisord.conf}
export SUPERVISORLOGLEVEL=${SUPERVISORLOGLEVEL:-info}

exec /usr/bin/supervisord \
  --configuration=${SUPERVISORCONFIG} \
  --loglevel=${SUPERVISORLOGLEVEL} \
  --nodaemon
