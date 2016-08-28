#!/bin/sh

qemu-system-i386 -cpu pentium2 -m 256M   \
    -drive file=storesecure.img,id=rootdisk,format=raw,if=none -device ide-hd,model='LEGIT HARDDISK',serial='1mVdp0bPqodoNgjP',drive=rootdisk,bus=ide.0 \
    -vga cirrus \
    -nographic \
    -chardev socket,server,nowait,path=/run/watchdog/storesecure,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 \
    -net nic,macaddr=30:1a:28:ee:39:86,model=pcnet -net tap,ifname=storesecure &


sleep 1
./watcher storesecure >> /var/log/watcher-storesecure.log &

ip link set up dev storesecure
ip link set up dev cesspit

brctl addif cesspit storesecure

echo 'Waiting for the VM to die'
wait
