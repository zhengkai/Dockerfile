FROM debian:jessie

ENV PHP_INI_DIR            /etc/php
ENV PHP_CONF_DIR           $PHP_INI_DIR/conf.d

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/^# deb/deb/g' /etc/apt/sources.list
RUN cat /etc/apt/sources.list

ENV TZ Asia/Shanghai
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

RUN apt-get update
RUN apt-get install -y apt-utils

RUN apt-get install -y locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

RUN apt-get install -y ca-certificates curl wget

#
# deps
#
ENV PHPIZE_DEPS \
	git \
	autoconf \
	file \
	g++ \
	gcc \
	libc-dev \
	make \
	pkg-config \
	bison \
	re2c

ENV BUILD_DEPS \
	bzip2 \
	libcurl4-openssl-dev \
	libreadline6-dev \
	libssl-dev \
	libxml2-dev \
	libgmp-dev \
	libmhash-dev \
	libmcrypt-dev \
	libmemcached-dev

RUN apt-get install -y \
	$PHPIZE_DEPS \
	$BUILD_DEPS

RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

#
# php source
#
RUN set -x \
	&& wget -q "https://downloads.php.net/~ab/php-7.0.0RC6.tar.gz" -O php.tar.gz \
	&& echo "65f988bd99d430adb75e97e43320c9535c5e8686  php.tar.gz" | sha1sum -c \
	&& mkdir -p /usr/src/php \
	&& tar -xvf php.tar.gz -C /usr/src/php --strip-components=1 \
	&& rm php.tar.gz*

#
# configure && make
#
COPY config.nice /usr/src/php/config.nice

RUN cd /usr/src/php \
	&& ./config.nice \
		"--sysconfdir=$PHP_INI_DIR" \
		"--with-config-file-path=$PHP_INI_DIR" \
		"--with-config-file-scan-dir=$PHP_CONF_DIR" \
	&& make -j"$(nproc)" \
	&& strip --strip-all /usr/src/php/sapi/fpm/php-fpm \
	&& strip --strip-all /usr/src/php/sapi/cli/php \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

#
# ImageMagick
#
RUN apt-get install -y imagemagick

#
# Memcached
#
RUN git clone https://github.com/php-memcached-dev/php-memcached.git -b php7 /usr/src/php-memcached \
	&& cd /usr/src/php-memcached \
	&& phpize \
	&& ./configure --disable-memcached-session --disable-memcached-sasl \
	&& make -j"$(nproc)" \
	&& make install \
	&& rm -rf /usr/src/php-memcached

#
# Redis
#
RUN git clone https://github.com/phpredis/phpredis.git -b php7 /usr/src/phpredis \
	&& cd /usr/src/phpredis \
	&& phpize \
	&& ./configure --disable-redis-session \
	&& make -j"$(nproc)" \
	&& make install \
	&& rm -rf /usr/src/phpredis

#
# MongoDB
#
#RUN apt-get install -y libmongo-client-dev
#RUN git clone https://github.com/mongodb-labs/mongo-php-driver-prototype.git -b PHP7 /usr/src/pecl-mongodb \
#	&& cd /usr/src/pecl-mongodb \
#	&& git submodule update --init \
#	&& phpize \
#	&& ./configure --without-openssl --without-mongodb-sasl \
#	&& make -j"$(nproc)" \
#	&& make install \
#	&& rm -rf /usr/src/pecl-mongodb

#	&& cd src/libbson \
#	&& git pull origin master \
#	&& cd ../.. \
#	&& cd src/libmongoc \
#	&& git pull origin master \
#	&& cd ../.. \

#
# clean
#
RUN apt-get purge -y $PHPIZE_DEPS 
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/src/php

ADD etc/* $PHP_INI_DIR/
ADD etc/conf.d/* $PHP_CONF_DIR/

VOLUME ["/www", "/var/log/php"]

WORKDIR /www

RUN php -m

EXPOSE 9000
CMD ["php-fpm"]
