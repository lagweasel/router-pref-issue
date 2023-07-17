#!/bin/sh

mkdir -p /etc/systemd/system/systemd-networkd.service.d/
cp /vagrant/main/systemd-networkd/* /etc/systemd/system/systemd-networkd.service.d/
systemctl daemon-reload
systemctl restart systemd-networkd

cp /vagrant/main/netplan/* /etc/netplan/
chmod 600 /etc/netplan/50-netcfg.yaml
netplan apply

#apt-get update
#apt-get install -y radvdump traceroute
