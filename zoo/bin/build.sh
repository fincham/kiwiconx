#!/bin/bash

echo "*** Rebuilding and re-signing static.tar.gz..."

cd /opt/kiwicon/zoo

tar zcfv build/static.tar.gz ./static
cd build
rm static.tar.gz.asc
gpg --sign --detach -a -u 0x314983B53C8932BFD36335B7FEA3F6BF69FE8D5D static.tar.gz
mv static.tar.gz* /var/www/html/bff69625c22aa7c127e23931f158142a/
