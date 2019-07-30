#!/usr/bin/env bash
##
## This script runs node_exporter in the foreground.
##
## If you need to override these values, bind-mount a file as container volume over this file ("/app/node_exporter.sh").
set -euo pipefail

## Source the global process environment file.
source /app/env.sh



## ref: https://github.com/prometheus/node_exporter/issues/735#issuecomment-516466414
/usr/local/bin/node_exporter \
  --collector.supervisord \
  --collector.supervisord.url http://localhost:19001/RPC2 \
  --collector.textfile.directory ${BATCH_EXPORTER_DATA_DIR:-/data} \
  --no-collector.arp \
  --no-collector.bcache \
  --no-collector.bonding \
  --no-collector.conntrack \
  --no-collector.cpu \
  --no-collector.cpufreq \
  --no-collector.diskstats \
  --no-collector.edac \
  --no-collector.entropy \
  --no-collector.filefd \
  --no-collector.filesystem \
  --no-collector.hwmon \
  --no-collector.infiniband \
  --no-collector.ipvs \
  --no-collector.loadavg \
  --no-collector.mdadm \
  --no-collector.meminfo \
  --no-collector.netclass \
  --no-collector.netdev \
  --no-collector.netstat \
  --no-collector.nfs \
  --no-collector.nfsd \
  --no-collector.pressure \
  --no-collector.sockstat \
  --no-collector.stat \
  --no-collector.time \
  --no-collector.timex \
  --no-collector.uname \
  --no-collector.vmstat \
  --no-collector.xfs \
  --no-collector.zfs \
  --web.listen-address "${BATCH_EXPORTER_LISTEN_ADDRESS:-[::]:9500}"
