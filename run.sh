#!/bin/sh

envtpl /etc/telegraf/telegraf.conf.tpl

/bin/telegraf -config /etc/telegraf/telegraf.conf

