[![Build Status](https://cloud.drone.io/api/badges/cisco-cx/batch_exporter/status.svg)](https://cloud.drone.io/cisco-cx/batch_exporter)

# batch_exporter

This project is a remaster of the [prometheus/node_exporter](https://github.com/prometheus/node_exporter) Docker image. batch_exporter leverages node_exporter's [textfile collector](https://github.com/prometheus/node_exporter#textfile-collector) feature, which gives a way to export metrics on specially-formatted text files in a filesystem directory.

batch_exporter adds to node_exporter a multi-process manager called [supervisord](http://supervisord.org/). supervisord manages the process for node_exporter as well as any processes you need to pull data to the directory watched by textfile collector. supervisord can be configured to fail-fast when a process it manages dies. This feature allows us to cascade failures in processes managed down to the container scheduler (e.g. Kubernetes, docker-compose).

In this way, batch_exporter allows you to regularly fetch remote batch job results into the directory watched by node_exporter (e.g. using scp to download the source files and any other tools you need to process those files into the textcollector file format). In doing so, batch_exporter conveniently exposes batch-derived metrics.

The batch_exporter container image is designed to be used as a base image (used in the `FROM` line) of bespoke Dockerfiles that add scripts or other programs to fetch and transform unique classes of batch data (e.g. "refrigerator_batch_exporter").

## Docker Image

```bash
docker pull docker.io/ciscocx/batch_exporter:${DOCKER_TAG}
```

### Docker Compose example

ref: [docker-compose.yaml](./docker-compose.yaml)

```bash
DOCKER_TAG=${DOCKER_TAG:-0.1.0} docker-compose up
```

## Configuration

While default configuration files are built into the Docker image, you may bind-mount your own files over them as needed.

### env.sh

Because supervisord is used to manage multiple processes in the batch_exporter container, [env.sh](./env.sh) is used as the central environment variable configuration file. Variables exported in [env.sh](./env.sh) should be accessible in scripts like [node_exporter.sh](./node_exporter.sh) and [batch.sh](./batch.sh).

Please see the contents of [env.sh](./env.sh) for specific details about it.

## Remastering the Docker Image

*TL;DR: Using batch_exporter in your own foo_exporter.*

batch_exporter's goal is to be an ideal base image for your own bespoke Prometheus metrics batch exporters. In short, all you need to do is change a few files and publish your own Docker image (e.g. `your-docker-repo/batch_exporter_foo`).

More specifcially, to build upon batch_exporter, define your own `env.sh`, `batch.sh` in a new git repo. Then add an extensible `Dockerfile` like this:

```
FROM docker.io/ciscocx/batch_exporter

WORKDIR /app
COPY batch.sh .
COPY env.sh .
```
