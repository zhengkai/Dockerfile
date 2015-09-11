#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./name.inc.sh

sudo docker run \
	--name $DOCKER_NAME \
	-p 127.20.0.3:9000:9000 \
	-v /www:/www \
	-v /data/php/log:/var/log/php \
	-v /tmp:/tmp \
	-d \
	$IMAGE_NAME
