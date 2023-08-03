#!/bin/sh

mkdir -p /etc/systemd/system/systemd-networkd.service.d/
cp /vagrant/fix/systemd-networkd/* /etc/systemd/system/systemd-networkd.service.d/
systemctl daemon-reload
systemctl restart systemd-networkd

cp /vagrant/fix/netplan/* /etc/netplan/
chmod 600 /etc/netplan/50-netcfg.yaml
netplan apply

apt-get update
apt-get install -y radvdump

# install build prerequisites
apt-get install -y meson gperf libcap-dev libpcap-dev libmount-dev

# clone repo / fix branch and build / install / restart etc.
if [ ! -d systemd ]; then
    echo Cloning ssahani/systemd
    git clone --progress --branch ndisc-28426 https://github.com/ssahani/systemd.git
fi
cd systemd
git pull
rm -rf build
meson setup build
make install
systemctl daemon-reload
systemctl restart systemd-networkd

systemctl --version
