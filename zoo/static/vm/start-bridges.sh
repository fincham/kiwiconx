#!/bin/bash

brctl addbr cesspit
brctl addbr linknet
brctl addbr internet

ip link set up dev cesspit
ip link set up dev linknet
ip link set up dev internet

ifconfig internet 10.0.0.1/30

