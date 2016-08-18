#!/bin/sh

qemu-system-x86_64  -m 1G -kernel linux -initrd initrd.gz  \
     -append "console=ttyS0,9600n81" \
    -chardev socket,host=127.0.0.1,port=4556,id=gnc0,server,nowait \
    -device isa-serial,chardev=gnc0 -nographic
