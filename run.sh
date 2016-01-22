#!/bin/bash

envtpl /etc/telegraf/telegraf.conf.tpl

echo -n 'Waiting for InfluxDB API'
while ! (ret=$(curl -I -s "$INFLUXDB_URL/ping" -o /dev/null -w "%{http_code}"); [ $ret -eq 204 ]) do 
	echo -n '.' 
	sleep 3s
done
echo '\nInfluxDB API Ready'

telegraf -config /etc/telegraf/telegraf.conf

