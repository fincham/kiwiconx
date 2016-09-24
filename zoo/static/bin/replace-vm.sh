#!/bin/bash

deploy_key=0x314983B53C8932BFD36335B7FEA3F6BF69FE8D5D
deploy_host=https://st01.fincham.kiwicon.org/bff69625c22aa7c127e23931f158142a

download_and_verify() {
    echo "Downloading $1..."
    intermediate="$(mktemp)"
    wget -O "${intermediate}" ${deploy_host}/$1 >/dev/null 2>&1
    wget -O "${intermediate}.asc" ${deploy_host}/$1.asc >/dev/null 2>&1;
    echo "Verifying $1..."
    if gpg --verify "${intermediate}.asc" "${intermediate}" >/dev/null 2>&1; then
        mv "${intermediate}" "$2"
        rm "${intermediate}.asc"
    else
        echo "fail: A file failed to validate, specifically \`$1'. The failed file is in \`$intermediate'."
        exit 1
    fi
}

if [[ $# -lt 1 ]]; then
    echo "Run this script with the name of a VM to re-deploy it."
    exit 1
fi

echo "*** Fetching cryptographic handwaves..."

if ! gpg --keyserver pgp.net.nz --recv-keys $deploy_key; then
    echo "fail: Couldn't get the PGP key everything is signed with."
    exit 1
fi

echo "*** Attempting to re-provision the VM \`$1'..."

if [[ ! -f /opt/kiwicon/zoo/vm/start-$1.sh ]]; then
    echo "fail: I don't even think that VM exists."
else
    download_and_verify $1.img /opt/kiwicon/zoo/vm/new-$1.img
    echo "Stopping $1..."
    supervisorctl stop $1
    mv /opt/kiwicon/zoo/vm/new-$1.img /opt/kiwicon/zoo/vm/$1.img
    echo "Starting $1..."
    supervisorctl start $1
fi
