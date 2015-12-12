FROM debian:jessie

MAINTAINER Zheng Kai "zhengkai@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get install -y locales \
	&& rm -r /var/lib/apt/lists/*
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

ENV TZ Asia/Shanghai
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

COPY nginx.list /etc/apt/sources.list.d/nginx.list

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html", "/log", "/www"]

RUN apt-get update \
	&& apt-get install -y ca-certificates nginx \
	&& rm -r /var/lib/apt/lists/*

RUN echo 'fastcgi_param SCRIPT_FILENAME $request_filename;' >> /etc/nginx/fastcgi_params 

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx
CMD ["nginx", "-g", "daemon off;"]
