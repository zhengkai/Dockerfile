#!/bin/bash

DOCKER_NAME='php7'
IMAGE_NAME='zhengkai/php'

cd $(dirname `readlink -f $0`)

sudo docker stop $DOCKER_NAME 2>/dev/null \
	&& sudo docker rm $DOCKER_NAME 2>/dev/null

build_param=''
if [[ "${@: -1}" == "reset" ]]; then
	build_param='--force-rm=true --no-cache=true'
fi

set -e

sudo docker build $build_param --tag $IMAGE_NAME .
