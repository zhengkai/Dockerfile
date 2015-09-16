#!/bin/bash
cd $(dirname `readlink -f $0`)
. ./service.inc.sh

data_base='/data'
data_list=(
	'nginx/log'
	'nginx/tmp'
	'nginx/vhost'
	'nginx/conf'
	'nginx/ssl'
	'php/log'
	'php/tmp'
	'mysql/log'
	'mysql/data'
)

for dir in ${data_list[@]}; do
	dir=$data_base/$dir
	echo $dir
	sudo mkdir -p $dir
done
sudo chown zhengkai:zhengkai -R $data_base

sudo mkdir -p /www
# sudo chown zhengkai:zhengkai -R /www

for service in ${service_list[@]}; do
	sudo docker stop $service 2>/dev/null
	sudo docker rm $service 2>/dev/null
done

sudo docker run \
	--name memcache \
	-d \
	memcached:latest

sudo docker run \
	--name mysql \
	--env MYSQL_ROOT_PASSWORD=t1oPR58DJDg6nFM8 \
	-v /data/mysql/log:/var/log/mysql \
	-v /data/mysql/data:/var/lib/mysql \
	-d \
	mysql:latest

sudo docker run \
	--name php \
	--link mysql:mysql \
	--link memcache:memcache \
	-v /www:/www \
	-v /data/php/log:/var/log/php \
	-v /tmp:/tmp \
	-d \
	zhengkai/php

sudo docker run \
	--name nginx \
	--link php:php \
	-p 443:443 \
	-p 80:80 \
	-v /www:/www \
	-v /data/nginx/vhost:/etc/nginx/sites-enabled \
	-v /data/nginx/log:/log \
	-v /data/nginx/ssl:/etc/nginx/certs \
	-v /tmp:/tmp \
	-d \
	zhengkai/nginx
