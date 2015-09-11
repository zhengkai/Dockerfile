#!/bin/bash

DOCKER_NAME='nginx18'
IMAGE_NAME='zhengkai/nginx'

cd $(dirname `readlink -f $0`)

sudo docker stop $DOCKER_NAME
sudo docker rm $DOCKER_NAME

build_param=''
if [[ "${@: -1}" == "reset" ]]; then
	build_param='--force-rm=true --no-cache=true'
fi

set -e

sudo docker build $build_param --tag $IMAGE_NAME .

./install.sh
