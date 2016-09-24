#!/bin/sh

qemu-system-i386 -cpu pentium2 -m 192M   \
    -vnc 127.0.0.1:2 \
    -drive file=commsecure.img,id=rootdisk,format=raw,if=none -device ide-hd,model='I THINK I SAW BIGFOOT',serial='kCMmGSpzVd4AmLOI',drive=rootdisk,bus=ide.0 \
    -vga cirrus \
    -nographic \
    -chardev socket,server,nowait,path=/run/watchdog/commsecure,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 \
    -net nic,macaddr=30:1a:28:1a:c8:e1,model=pcnet -net tap,ifname=commsecure &

pid=$!
sleep 1
./watcher commsecure $pid >> /var/log/watcher-commsecure.log &

ip link set up dev commsecure
ip link set up dev cesspit

brctl addif cesspit commsecure

echo 'Waiting for the VM to die'
wait
