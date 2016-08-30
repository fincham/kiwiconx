#!/bin/sh

qemu-system-i386 -cpu pentium -m 64M   \
    -nographic \
    -vnc 127.0.0.1:0 \
    -drive file=airgap.img,id=rootdisk,format=raw,if=none -device ide-hd,model='PROBABLY A COMPACTFLASH OR SOMETHING',serial='J8gJYDhqsgBy5F1R',drive=rootdisk,bus=ide.0 \
    -chardev socket,server,nowait,path=/run/watchdog/airgap,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 \
    -net nic,macaddr=30:1a:28:de:01:89,model=pcnet -net tap,ifname=airgap-in \
    -net nic,macaddr=30:1a:28:2b:7f:32,model=pcnet -net tap,ifname=airgap-out &

pid=$!
sleep 1
./watcher airgap $pid >> /var/log/watcher-airgap.log &

ip link set up dev airgap-out
ip link set up dev airgap-in
ip link set up dev linknet
ip link set up dev cesspit

brctl addif linknet airgap-out
brctl addif cesspit airgap-in

echo 'Waiting for the VM to die'
wait

