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
	'mysql/conf'
	'redis/log'
	'redis/data'
	'mongodb/log'
	'mongodb/data'
)

for dir in ${data_list[@]}; do
	dir=$data_base/$dir
	echo $dir
	sudo mkdir -p $dir
done
sudo chown zhengkai:zhengkai -R $data_base

sudo mkdir -p /www
# sudo chown zhengkai:zhengkai -R /www

for ((i=${#service_list[@]}-1; i>=0; i--)); do
	sudo docker stop ${service_list[$i]} 2>/dev/null
	sudo docker rm ${service_list[$i]} 2>/dev/null
done

sudo docker run \
	--name memcache \
	-d \
	memcached:latest

#sudo docker run \
#	--name redis \
#	-v /data/redis/log:/var/log/redis \
#	-v /data/redis/data:/data \
#	-d \
#	redis:latest

#sudo docker run \
#	--name mongo \
#	-v /data/mongodb/data:/data/db \
#	-d \
#	mongo:latest

sudo docker run \
	--name mysql \
	--env MYSQL_ROOT_PASSWORD=t1oPR58DJDg6nFM8 \
	-v /data/mysql/log:/var/log/mysql \
	-v /data/mysql/data:/var/lib/mysql \
	-v /data/mysql/conf:/etc/mysql/conf.d \
	-d \
	mysql:latest

sudo docker run \
	--name php \
	--link mysql:mysql \
	--link memcache:memcache \
	-v /www:/www \
	-v /data/php/log:/var/log/php \
	-v /data/php/tmp:/tmp \
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
