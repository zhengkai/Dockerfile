#!/bin/bash -ex

cd /dev
mkdir net
chmod 666 net
cd net
mknod tun c 10 200
chmod 666 tun

/usr/sbin/openvpn --mktun --dev tun

/usr/sbin/openvpn --daemon nordvpn --config /etc/openvpn/config.conf
# /usr/sbin/openvpn --config /etc/openvpn/config.conf

cat /etc/resolv.conf

ifconfig

/usr/sbin/danted
