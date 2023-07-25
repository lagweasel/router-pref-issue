#!/bin/sh

vagrant ssh -c "sudo birdc show protocols radv_h" router_h
vagrant ssh -c "sudo birdc show protocols radv_m" router_m
