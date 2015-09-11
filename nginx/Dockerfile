FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update 
RUN apt-get install -y apt-utils

RUN apt-get install -y locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

RUN apt-get install -y ca-certificates curl wget

ENV TZ Asia/Shanghai
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

RUN wget "http://nginx.org/keys/nginx_signing.key" -O /tmp/nginx_signing.key
RUN apt-key add /tmp/nginx_signing.key

COPY nginx.list /etc/apt/sources.list.d/nginx.list

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html", "/log", "/www"]

RUN apt-get update
RUN apt-get install nginx

RUN echo 'fastcgi_param SCRIPT_FILENAME $request_filename;' >> /etc/nginx/fastcgi_params

ADD nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx
CMD ["nginx", "-g", "daemon off;"]
