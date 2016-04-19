# docker-telegraf

Docker Image for [InfluxData Telegraf](https://influxdata.com/time-series-platform/telegraf/).

## Run

You may need to replace the path to */var/run/docker.sock* depending on the location of your docker socket.

Most basic form:
```
docker run -t -v /var/run/docker.sock:/var/run/docker.sock appcelerator/telegraf
```

Custom InfluxDB location and additional tags:
```
docker run -t -v /var/run/docker.sock:/var/run/docker.sock -e INFLUXDB_URL=http://influxdb:8086 -e TAG_datacenter=eu-central-1 -e TAG_type=core appcelerator/telegraf
```

# Configuration (ENV, -e)
- INFLUXDB_URL - Where is your InfluxDB running? (default: http://localhost:8086) Note: No trailing slash!
- HOSTNAME - To pass in the docker host's actual hostname
- TAG_<name> - Adds a tag with the given value to all measurements

## Tags

- latest
