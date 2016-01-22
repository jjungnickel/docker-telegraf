#!/bin/bash

envtpl /etc/telegraf/telegraf.conf.tpl

telegraf -config /etc/telegraf/telegraf.conf

