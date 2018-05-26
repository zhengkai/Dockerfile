#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./name.inc.sh

sudo docker network create --subnet=192.168.100.0/24 vpn >/dev/null

sudo docker run \
	--name $DOCKER_NAME \
	--cap-add=NET_ADMIN \
	--net vpn \
	--ip 192.168.100.100 \
	--dns 103.86.96.100 \
	--dns 103.86.99.100 \
	--restart=always \
	-p 9010:1080 \
	-d \
	$IMAGE_NAME
