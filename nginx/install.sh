#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./name.inc.sh

sudo docker run \
	--name $DOCKER_NAME \
	-p 127.50.0.1:443:443 \
	-p 127.50.0.1:80:80 \
	-v /www:/www \
	-v /data/nginx/vhost:/etc/nginx/sites-enabled \
	-v /data/nginx/log:/log \
	-v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
	-v /tmp:/tmp \
	-d \
	$IMAGE_NAME
