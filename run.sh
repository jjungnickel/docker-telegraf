#!/bin/sh

echo "Configured inputs:"
echo "Kafka:           $INPUT_KAFKA_ENABLED"
echo "CPU:             $INPUT_CPU_ENABLED"
echo "Disk:            $INPUT_DISK_ENABLED"
echo "Disk I/O:        $INPUT_DISKIO_ENABLED"
echo "Kernel:          $INPUT_KERNEL_ENABLED"
echo "Memory:          $INPUT_MEM_ENABLED"
echo "Process:         $INPUT_PROCESS_ENABLED"
echo "Swap:            $INPUT_SWAP_ENABLED"
echo "System:          $INPUT_SYSTEM_ENABLED"
echo "Docker:          $INPUT_DOCKER_ENABLED"

echo "Configured outputs:"
echo "InfluxDB:       $OUTPUT_INFLUXDB_ENABLED"
echo "Cloudwatch:     $OUTPUT_CLOUDWATCH_ENABLED"
echo "Kafka:          $OUTPUT_KAFKA_ENABLED"

if [[ -f /etc/telegraf/telegraf.conf.tpl ]] ; then
    echo "Generating /etc/telegraf/telegraf.conf from template..."
    envtpl /etc/telegraf/telegraf.conf.tpl
else
    if [[ -f /etc/telegraf/telegraf.conf ]] ; then
        echo "/etc/telegraf/telegraf.conf already exists. Nothing to do."
    else
        echo "ERROR: No template or configuration file found: /etc/telegraf/telegraf.conf"
    fi
fi

/bin/telegraf -config /etc/telegraf/telegraf.conf
