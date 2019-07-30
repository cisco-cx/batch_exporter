# This file defines the environment variables for supervisord process that source it (e.g. node_exporter).\
#
# If you need to override these values, bind-mount a file as container volume over this file ("/app/env.sh").
export BATCH_EXPORTER_DATA_DIR="/data"
export BATCH_EXPORTER_LISTEN_ADDRESS="[::]:9500"
export BATCH_EXPORTER_NAME="batch_exporter_example"
export BATCH_EXPORTER_POST_BATCH_SLEEP_SECONDS="60"
export BATCH_EXPORTER_LOGLEVEL="info"  # (info|debug)
