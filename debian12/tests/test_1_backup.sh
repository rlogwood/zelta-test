#!/bin/sh -x

# setup environment fresh

# fresh pools
./pool_setup.sh

# confirmation of pools and file systems
zpool list

zfs list

# make fresh tree
./make-snap-tree.sh

# confirm the tree by log inspection
zfs list

# perform backup
zelta backup apool bpool/Backups/apool
