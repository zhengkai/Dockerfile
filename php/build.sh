#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./name.inc.sh

build_param=''
if [[ "${@: -1}" == "reset" ]]; then
	build_param='--force-rm=true --no-cache=true'
fi

set -e

sudo docker build $build_param --tag $IMAGE_NAME'_build' .

sudo docker tag -f $IMAGE_NAME'_build' $IMAGE_NAME

./install.sh
