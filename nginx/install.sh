#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./name.inc.sh

sudo docker run \
	--name $DOCKER_NAME \
	-p 443:443 \
	-p 80:80 \
	-v /www:/www \
	-v /data/nginx/vhost:/etc/nginx/sites-enabled \
	-v /data/nginx/log:/log \
	-v /data/nginx/ssl:/etc/nginx/certs \
	-v /tmp:/tmp \
	-d \
	$IMAGE_NAME
