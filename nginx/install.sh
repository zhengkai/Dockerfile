#!/bin/bash

DOCKER_NAME='nginx18'
IMAGE_NAME='zhengkai/nginx'

cd $(dirname `readlink -f $0`)

sudo docker stop $DOCKER_NAME
sudo docker rm $DOCKER_NAME

sudo docker run \
	--name $DOCKER_NAME \
	-p 127.50.0.1:443:443 \
	-p 127.50.0.1:80:80 \
	-v /data/nginx/vhost:/etc/nginx/sites-enabled \
	-v /data/nginx/log:/log \
	-v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
	-d \
	$IMAGE_NAME
