#!/bin/sh -x

set +e

# Simulate a failback event, where we have a source/target pair of apool/treetop / bpool/treetop:

zfs rename apool/treetop apool/treetop-backup

zelta clone apool/treetop-backup apool/treetop
#zelta sync -c apool/treetop-backup  apool/treetop

# And then detect and continue the replication without wasting space:
# You'll end up with a new dataset: bpool/treetop-last_snapshot_name

#zelta backup -S --rotate apool/treetop4 bpool/treetop4
zelta backup -S --rotate apool/treetop bpool/treetop


dataset_arg="bpool/treetop"

last_snapshot_name=$(last_snapshot_name $dataset_arg)


#last_snapshot_name=$(zfs list -t snapshot -o name,creation -s creation -r bpool/treetop | grep 'bpool/treetop@' | awk -F'@' '{print "@" $2}' | awk '{print $1}')

zfs list bpool/treetop@$last_snapshot_name

if [ $? -eq 1 ];  then
    echo "ERROR: This test depends on test_backup.sh, please run it first"
    exit 1
fi   

