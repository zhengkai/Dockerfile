#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./service.inc.sh

for ((i=${#service_list[@]}-1; i>=0; i--)); do
	sudo docker stop ${service_list[$i]} 2>/dev/null
done
