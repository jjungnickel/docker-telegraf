#!/bin/bash
sed -i 's@INFLUXDB_URL@'$INFLUXDB_URL'@' /etc/telegraf/telegraf.conf
echo -n 'Waiting for InfluxDB API'
while ! (ret=$(curl -I -s "$INFLUXDB_URL/ping" -o /dev/null -w "%{http_code}"); [ $ret -eq 204 ]) do 
	echo -n '.' 
	sleep 3s
done
echo '\nInfluxDB API Ready'
telegraf -config /etc/telegraf/telegraf.conf

