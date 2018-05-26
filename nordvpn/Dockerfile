FROM ubuntu:bionic

MAINTAINER Zheng Kai "zhengkai@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN cat /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		locales ca-certificates net-tools curl dnsutils \
		openvpn dante-server \
	&& rm -r /var/lib/apt/lists/*

RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN locale-gen

COPY vpnconfig/config.conf /etc/openvpn/config.conf
COPY vpnconfig/pwd /etc/openvpn/pwd
RUN chmod 400 /etc/openvpn/pwd

RUN ls -al /etc/openvpn

RUN ifconfig

EXPOSE 1080

COPY run.sh /root/run.sh
RUN chmod +x /root/run.sh

COPY danted.conf /etc/danted.conf

CMD ["/root/run.sh"]
