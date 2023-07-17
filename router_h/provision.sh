#!/bin/sh

cp /vagrant/router_h/netplan/* /etc/netplan/
chmod 600 /etc/netplan/50-netcfg.yaml
netplan apply

apt-get update
apt-get install -y bird2

cp /vagrant/router_h/bird/* /etc/bird/
birdc configure
