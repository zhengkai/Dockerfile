#!/bin/bash

DOCKER_NAME='php7'
IMAGE_NAME='test/php7'

cd $(dirname `readlink -f $0`)

sudo docker run \
	--name $DOCKER_NAME \
	-p 127.20.0.3:9000:9000 \
	-v /www:/www \
	-v /tmp/php-error.txt:/var/log/php/php-error.txt \
	-v /tmp:/tmp \
	-d \
	$IMAGE_NAME
