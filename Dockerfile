## Multi-stage build

## Source Stage: node_exporter
FROM quay.io/prometheus/node-exporter:v0.18.1

## Output Stage: batch_exporter
FROM debian:stretch-slim
WORKDIR /usr/local/bin
COPY --from=0 /bin/node_exporter .

# Install System Programs
RUN apt-get update && apt-get --no-install-recommends -y install \
    # Add core programs \
    supervisor syslog-ng ca-certificates coreutils expect git openssh-client \
    # Add Debugging Tools (Removable in the future) \
    iproute2 net-tools nmap curl wget dnsutils file && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

# Install tini
RUN cd /tmp && \
    wget -O tini https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64 && \
    chmod 755 tini && \
    mv tini /sbin/tini

SHELL ["/bin/bash", "-c"]

# Create a new user
WORKDIR /app
RUN set -euo pipefail && \
    addgroup --gid 1000 --system app && \
    adduser  --uid 1000 --system --ingroup app --home /app --no-create-home app
# TODO: Run as user app
# USER app

# All configs relevant to this Dockerfile are kept in /app
COPY entrypoint.sh .
COPY supervisor.d ./supervisor.d
COPY node_exporter.sh .
COPY sigquit-supervisord.sh .
RUN rmdir /etc/supervisor/conf.d && \
    ln -s /app/supervisor.d /etc/supervisor/conf.d && \
    chown -R 1000:1000 -R /app /var/log

#COPY snmptrapd.conf .  # TODO: config for node_exporter, etc.

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/app/entrypoint.sh"]
