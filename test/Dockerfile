FROM debian:jessie

ENV PHP_INI_DIR            /etc/php
ENV PHP_CONF_DIR           $PHP_INI_DIR/conf.d

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Asia/Shanghai
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

RUN apt-get update
RUN apt-get install -y apt-utils 

RUN apt-get install -y locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

RUN apt-get install -y ca-certificates curl wget

EXPOSE 9000
CMD ["bash"]
