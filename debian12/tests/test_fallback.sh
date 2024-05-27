#!/bin/sh -x

set +e

echo "NOTE: This test depends on test_backup.sh, please run it first"

# Simulate a failback event, where we have a source/target pair of apool/treetop / bpool/treetop:
zfs rename apool/treetop apool/treetop-backup

zelta clone apool/treetop-backup apool/treetop

# And then detect and continue the replication without wasting space:
# You'll end up with a new dataset: bpool/treetop-last_snapshot_name

zelta backup -S --rotate apool/treetop bpool/treetop

dataset_arg="bpool/treetop"

last_snapshot_name=$(find_last_snapshot_name $dataset_arg)

zfs list bpool/treetop@$last_snapshot_name
