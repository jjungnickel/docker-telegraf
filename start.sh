#!/bin/bash


#display env. variables
echo ---------------------------------------------------------------------------
echo "Configured outputs:"
echo "CONSUL: "$CONSUL
echo "InfluxDB:     $OUTPUT_INFLUXDB_ENABLED"
echo "Cloudwatch:   $OUTPUT_CLOUDWATCH_ENABLED"
echo "Kafka:        $OUTPUT_KAFKA_ENABLED"
if [ -z "$CONSUL" ]; then
  envtpl /etc/telegraf/telegraf.conf.tpl
  exec /bin/telegraf -config /etc/telegraf/telegraf.conf
else
  #update containerpilot conffile
  sed -i "s/\[consul\]/$CONSUL/g" /etc/containerpilot.json
  echo ---------------------------------------------------------------------------
  echo containerPilot conffile
  cat /etc/containerpilot.json
  echo ---------------------------------------------------------------------------
  while true
  do
    ready=0
    while [ "$ready" != "1" ]
      do
      ready=1
      for service in $DEPENDENCIES
      do
        status=$(curl --max-time 3 -s http://consul:8500/v1/health/checks/$service)
        if [[ $status =~ ^.*\"Status\":\"passing\" ]]; then
          echo $service" is ready"
        else
          echo $service" is not yet ready"
          ready=0
        fi
      done
      if [ "$ready" == "0" ]; then
        echo "Waiting for dependencies"
        sleep 10
      fi
    done
    sleep 3
    echo "All dependencies are ready"
    envtpl /etc/telegraf/telegraf.conf.tpl
    /bin/containerpilot /bin/telegraf -config /etc/telegraf/telegraf.conf 
done
fi