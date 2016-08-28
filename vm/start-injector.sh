#!/bin/sh

qemu-system-x86_64  -m 1G   \
    -hda injector.img \
    -nographic \
    -netdev tap,id=injector-out,ifname=injector-out,script=no -device virtio-net,mac=30:1a:28:2d:ba:79,netdev=injector-out \
    -netdev tap,id=injector-in,ifname=injector-in,script=no -device virtio-net,mac=30:1a:28:ae:b0:5e,netdev=injector-in &

sleep 1

ip link set up dev injector-out
ip link set up dev injector-in
ip link set up dev linknet
ip link set up dev internet

brctl addif linknet injector-in
brctl addif internet injector-out


echo 'Waiting for the VM to die'
wait

