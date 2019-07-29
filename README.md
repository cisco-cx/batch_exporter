[![Build Status](https://cloud.drone.io/api/badges/cisco-cx/batch_exporter/status.svg)](https://cloud.drone.io/cisco-cx/batch_exporter)

# batch_exporter

This project is a remaster of the [prometheus/node_exporter](https://github.com/prometheus/node_exporter) Docker image. batch_exporter leverages node_exporter's [textfile collector](https://github.com/prometheus/node_exporter#textfile-collector) feature, which gives a way to export metrics on specially-formatted text files in a filesystem directory.

batch_exporter adds to node_exporter a multi-process manager called [supervisord](http://supervisord.org/). supervisord manages the process for node_exporter as well as any processes you need to pull data to the directory watched by textfile collector. supervisord can be configured to fail-fast when a process it manages dies. This feature allows us to cascade failures in processes managed down to the container scheduler (e.g. Kubernetes, docker-compose).

In this way, batch_exporter allows you to regularly fetch remote batch job results into the directory watched by node_exporter (e.g. using scp to download the source files and any other tools you need to process those files into the textcollector file format). In doing so, batch_exporter conveniently exposes batch-derived metrics.

The batch_exporter container image is designed to be used as a base image (used in the `FROM` line) of bespoke Dockerfiles that add scripts or other programs to fetch and transform unique classes of batch data (e.g. "refrigerator_batch_exporter").

## Usage

Pulling this image from our private GCR registry requires prior configuration of `gcloud`. An introduction to how to configure `gcloud` for `docker pull` is mentioned [here](https://github.com/cisco-cx/batch_exporter/tree/master/sandboxes/of#start-all-dockerized-services).

```bash
docker pull docker.io/ciscocx/batch_exporter:${DOCKER_TAG}  # Requires pre-existing gcloud config.
```

Tags: https://console.cloud.google.com/gcr/images/ciscocx/ASIA/batch_exporter

### Docker Compose example

ref: [docker-compose.yaml](./docker-compose.yaml)

```bash
DOCKER_TAG=${DOCKER_TAG:-0.1.0} docker-compose up
```

## Configuration

TODO

The most important configuration files are:

* ~~[todo.yaml](./todo.yaml) description goes here~~

While default configuration files are built into the Docker image, you may bind mount your own files over them.

## Development Notes

### From another container within a docker-compose network

```
TODO
```

### From the Host of a docker-compose network

```
TODO
```

## From localhost of the container itself

```
TODO
```
