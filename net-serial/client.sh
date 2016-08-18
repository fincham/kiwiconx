#!/bin/sh

socat unix-listen:/tmp/console.sock tcp4:127.0.0.1:4556 &
minicom -D unix\#/tmp/console.sock
