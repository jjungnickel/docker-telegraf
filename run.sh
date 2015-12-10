#!/bin/bash
sed -i 's@INFLUXDB_URL@'$INFLUXDB_URL'@' /etc/kapacitor/kapacitor.conf
kapacitord -hostname $HOSTNAME -config /etc/kapacitor/kapacitor.conf
