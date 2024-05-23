#!/bin/sh -x

zpool destroy apool
zpool destroy bpool

# NOTE: these devices are specific to the test env
zpool create apool /dev/nvme0n1
zpool create bpool /dev/nvme1n1
