#!/usr/bin/env bash
##
## This script ("/app/batch.sh") runs batch collection commands in the foreground.
##
## supervisord runs node_exporter in a configuration that exports the metrics you publish to the collector data directory.
##
## ref: https://github.com/prometheus/node_exporter#textfile-collector
## 
## Batch collection commands should atomically write files into the collector data directory (e.g. "/app/collector/data").
##
## Regardless of exit code, supervisord is configured to quit (**exit 0**) when this script exits for any reason.
##
## Therefore, your batch collection commands should be wrapped in a loop.
##
## Inside the loop, you must implement any timeout logic if you desire that.
##
## If you want to customize this script, you can bind-mount a file as container volume over this file ("/app/batch.sh").
## 
## If remastering the batch_exporter image, you can overwrite this file in your Dockerfile.
##
## STDERR and STDOUT of this script are configured to output through supervisord's STDERR and STDOUT.
##
set -euo pipefail

case ${BATCH_EXPORTER_LOGLEVEL:-info} in
  debug)
    set -x
  ;;
esac

## Source the global process environment file.
source /app/env.sh

## Confirm env vars and give them readable names.
name=${BATCH_EXPORTER_NAME}
data_dir=${BATCH_EXPORTER_DATA_DIR:-/data}
post_sleep_seconds=${BATCH_EXPORTER_POST_BATCH_SLEEP_SECONDS:-60}

## Set file helper vars.
live_file=${data_dir}/${name}.prom  ## Live file is where the stage file is copied after your batch is fully recorded.
                                    ## node_exporter's textfile collector will scrape this file.
stage_file=${live_file}.stage       ## Stage file is the metrics data file you append to until your batch is fully recorded.

## Stage and publish batch metrics as a loop in the foreground.
while true; do

  ## Create and optionally append to a staged metrics file for your batch.
  ## <YOUR_BATCH_COMMANDS_HERE>, e.g.
  echo "${name}_foo_count ${RANDOM}" > ${stage_file}
  echo "${name}_bar_count ${RANDOM}" >> ${stage_file}

  ## Set standard batch_exporter metadata for the batch.
  ## ref: https://github.com/prometheus/node_exporter#textfile-collector
  echo "${name}_completion_time $(date +%s)" >> ${stage_file}

  ## Atomically publish the batch metrics for scraping.
  mv ${stage_file} ${live_file}

  ## Sleep for user-defined number of seconds.
  echo "$(date --rfc-3339 seconds) Batch published. Sleeping for ${post_sleep_seconds} seconds..."
  sleep ${post_sleep_seconds}

done
