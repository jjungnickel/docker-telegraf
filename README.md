# docker-telegraf

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/jjungnickel/telegraf/) [![Docker Pulls](https://img.shields.io/docker/pulls/jjungnickel/telegraf.svg)](https://registry.hub.docker.com/u/jjungnickel/telegraf/)

Docker Image for [InfluxData Telegraf](https://influxdata.com/time-series-platform/telegraf/).

## Run

Most basic form:
```
docker run -t jjungnickel/telegraf
```

Custom InfluxDB location and additional tags:
```
docker run -t -e INFLUXDB_URL=http://influxdb:8086 -e TAG_datacenter=eu-central-1 -e TAG_type=core jjungnickel/telegraf
```

# Configuration (ENV, -e)
- INFLUXDB_URL - Where is your InfluxDB running? (default: http://localhost:8086) Note: No trailing slash!
- HOSTNAME - To pass in the docker host's actual hostname
- TAG_<name> - Adds a tag with the given value to all measurements

## Tags

- latest
- 0.10.0
