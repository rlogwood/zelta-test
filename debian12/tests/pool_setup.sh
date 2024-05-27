#!/bin/sh

echo "Creating new apool and bpool"

echo "APOOL_DISK:$APOOL_DISK"
echo "BPOOL_DISK:$BPOOL_DISK"

if [ -z "$APOOL_DISK$BPOOL_DISK" ]; then
    echo "ERROR: Define environment variables for APOOL_DISK and BPOOL_DISK"
    echo "for example APOOL_DISK=/dev/nvme?n1 where ? is your device #"
    exit 1
fi    

if [ $(id -u) -ne 0 ]; then
    echo "ERROR: you must run this script as root"
    exit 1
fi    

set -x

zpool destroy apool
zpool destroy bpool

zpool create apool $APOOL_DISK
zpool create bpool $BPOOL_DISK

zpool list
