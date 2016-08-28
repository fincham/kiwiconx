#!/bin/bash

deploy_key=0x314983B53C8932BFD36335B7FEA3F6BF69FE8D5D
deploy_host=

download_and_verify() {
    intermediate="$(mktemp)"
    wget -O "${intermediate}" $1
    wget -O "${intermediate}.asc" $1.asc
    if gpg --verify "${intermediate}.asc" "${intermediate}"; then
        mv "${intermediate}" "$2"
        rm "${intermediate}.asc"
    else
        echo "fail: A file failed to validate, specifically \`$1'."
        exit 1
    fi
}

echo "*** Checking some pre-requisites..."

cn="$(hostname -f)"

if [[ $(whoami) != "root" ]]; then
    echo "fail: This script has to be run as root on a freshly installed VM!"
    exit 1
fi

if ! egrep '^8\.' /etc/debian_version >/dev/null 2>&1; then
    echo "fail: You have to be using Debian Jessie."
    exit 1
fi

if ! host $cn 8.8.8.8 >/dev/null 2>&1; then
    echo "fail: The output of \`hostname -f' needs to be resolvable on the Internet so a TLS cert can be issued."
    exit 1
fi

echo "*** Fetching cryptographic handwaves..."

if ! gpg --keyserver pgp.net.nz --recv-keys $deploy_key; then
    echo "fail: Couldn't get the PGP key everything is signed with."
    exit 1
fi
