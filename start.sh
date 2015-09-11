#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./service.inc.sh

for service in ${service_list[@]}; do
	sudo docker start $service 2>/dev/null
done
