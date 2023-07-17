#!/bin/sh

vagrant ssh -c "sudo journalctl -b -u systemd-networkd | cat" main
