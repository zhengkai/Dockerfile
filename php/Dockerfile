FROM debian:jessie

MAINTAINER Zheng Kai "zhengkai@gmail.com"

ENV PHP_INI_DIR  /etc/php
ENV PHP_CONF_DIR $PHP_INI_DIR/conf.d

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/^# deb/deb/g' /etc/apt/sources.list

ENV TZ Asia/Shanghai
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

RUN apt-get update \
	&& apt-get install -y --no-install-recommends locales ca-certificates wget \
	&& rm -r /var/lib/apt/lists/*

RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

#
# deps
#
ENV PHPIZE_DEPS \
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
	libacl1-dev \
	librecode-dev \
	libxml2-dev \
	libgmp-dev \
	libmhash-dev \
	libbz2-dev \
	libtidy-dev \
	libmcrypt-dev

RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

ENV GPG_KEYS 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3
RUN set -xe \
	&& for key in $GPG_KEYS; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

#
# PHP
#
COPY config-fpm /usr/src/php/config-fpm
COPY config-cli /usr/src/php/config-cli

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $PHPIZE_DEPS $BUILD_DEPS \
	&& wget -q "http://cn.php.net/get/php-7.0.1.tar.gz/from/this/mirror" -O php.tar.gz \
	&& wget -q "http://cn.php.net/get/php-7.0.1.tar.gz.asc/from/this/mirror" -O php.tar.gz.asc \
	&& gpg --verify php.tar.gz.asc \
	&& mkdir -p /usr/src/php \
	&& tar -xvf php.tar.gz -C /usr/src/php --strip-components=1 \
	&& rm php.tar.gz \
	&& rm php.tar.gz.asc \
	&& cd /usr/src/php \
	&& ./config-fpm \
	&& make -j"$(nproc)" \
	&& strip --strip-all sapi/fpm/php-fpm \
	&& make install \
	&& make clean \
	&& ./config-cli \
	&& make -j"$(nproc)" \
	&& strip --strip-all sapi/cli/php \
	&& strip --strip-all modules/*.a \
	&& strip --strip-all modules/*.so \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHPIZE_DEPS \
	&& rm -r /var/lib/apt/lists/* \
	&& rm -r /usr/src/php

#
# Memcached
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends libz-dev libmemcached-dev git $PHPIZE_DEPS \
	&& git clone https://github.com/php-memcached-dev/php-memcached.git -b php7 /usr/src/php-memcached \
	&& cd /usr/src/php-memcached \
	&& phpize \
	&& ./configure --disable-memcached-session --disable-memcached-sasl \
	&& make -j"$(nproc)" \
	&& strip --strip-all modules/*.so \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false libz-dev libmemcached-dev git $PHPIZE_DEPS \
	&& rm -r /var/lib/apt/lists/* \
	&& rm -r /usr/src/php-memcached

#
# Msgpack
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends $PHPIZE_DEPS \
	&& wget -q "http://pecl.php.net/get/msgpack-2.0.0.tgz" -O php-msgpack.tgz \
	&& mkdir /usr/src/php-msgpack \
	&& tar -xvf php-msgpack.tgz -C /usr/src/php-msgpack --strip-components=1 \
	&& cd /usr/src/php-msgpack \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHPIZE_DEPS \
	&& rm -r /var/lib/apt/lists/* \
	&& rm -r /usr/src/php-msgpack

#
# Redis
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends git $PHPIZE_DEPS \
	&& git clone https://github.com/phpredis/phpredis.git -b php7 /usr/src/phpredis \
	&& cd /usr/src/phpredis \
	&& phpize \
	&& ./configure --disable-redis-session \
	&& make -j"$(nproc)" \
	&& strip --strip-all modules/*.so \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false git $PHPIZE_DEPS \
	&& rm -r /usr/src/phpredis

#
# MongoDB
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends libsasl2-dev libssl-dev git $PHPIZE_DEPS \
	&& git clone https://github.com/mongodb-labs/mongo-php-driver-prototype.git -b PHP7 /usr/src/pecl-mongodb \
	&& cd /usr/src/pecl-mongodb \
	&& git submodule update --init \
	&& phpize \
	&& ./configure --without-mongodb-sasl \
	&& make -j"$(nproc)" \
	&& strip --strip-all modules/*.so \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false libsasl2-dev libssl-dev git $PHPIZE_DEPS \
	&& apt-get -y autoremove \
	&& rm -r /var/lib/apt/lists/* \
	&& rm -r /usr/src/pecl-mongodb

#
# Xdebug
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends $PHPIZE_DEPS \
	&& wget -q "http://xdebug.org/files/xdebug-2.4.0rc3.tgz" -O php-xdebug.tgz \
	&& mkdir /usr/src/php-xdebug \
	&& tar -xvf php-xdebug.tgz -C /usr/src/php-xdebug --strip-components=1 \
	&& cd /usr/src/php-xdebug \
	&& phpize \
	&& ./configure \
	&& make -j"$(nproc)" \
	&& strip --strip-all modules/*.so \
	&& make install \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHPIZE_DEPS \
	&& rm -r /var/lib/apt/lists/* \
	&& rm -r /usr/src/php-xdebug

#
# ImageMagick
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends imagemagick \
	&& rm -r /var/lib/apt/lists/*

COPY etc $PHP_INI_DIR

RUN ls -al $PHP_INI_DIR/*

VOLUME ["/www", "/var/log/php"]

WORKDIR /www

RUN php -m

EXPOSE 9000
CMD ["php-fpm"]
