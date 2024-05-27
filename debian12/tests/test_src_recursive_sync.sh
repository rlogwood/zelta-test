#!/bin/sh -x

set +e

dataset_arg="apool"

#sync_output=$(zelta sync -sR $dataset_arg bpool/Backups/src-apool-backup)
sync_output="dummy"

# NOTE: use -v to see what's causing the problem
zelta sync -sR $dataset_arg bpool/Backups/src-apool-backup

last_snapshot_name=$(find_last_snapshot_name $dataset_arg)
#zfs list -t snapshot bpool/Backups/src-apool-backup/treetop-backup
treetop_backup_dataset="bpool/Backups/src-apool-backup/treetop-backup"

#zfs list -t snapshot $treetop_backup_dataset | tail -2 | head -1


backup_snapshot_name=$(find_last_snapshot_name $treetop_backup_dataset 2)
echo "treetop backup snapshot name"
echo $treetop_backup_snapshot_name

echo "last snapshot: $last_snapshot_name"

zfs list -r bpool/Backups/src-apool-backup

exit

echo "sync_output"
echo $sync_output
              
placeholder_output=$(cat <<'END'
source snapshot created: @{last_snapshot_name}
replicating 1 streams
found clone origin bpool/Backups/src-apool-backup/treetop-backup@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/vol1@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/minus@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/minus/two@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/minus/two/one@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/minus/two/one/0@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/minus/two/one/0/lift off@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/add@{backup_snapshot_name}
found clone origin bpool/Backups/src-apool-backup/treetop-backup/add/7@{backup_snapshot_name}
2M sent, 62/62 streams received in {time} seconds
END
)

cmd="echo \"$placeholder_output\" | sed s/{last_snapshot_name}/"$last_snapshot_name"/g | sed s/{backup_snapshot_name}/"$backup_snapshot_name"/g | sed 's/received in [0-9.]\+ seconds/received in {time} seconds/'"

expected_output=$(eval $cmd)

sync_output_no_time=$(echo $sync_output | sed 's/received in [0-9.]\+ seconds/received in {time} seconds/')

echo "sync command output without time is:"
echo $sync_output_no_time
echo ""
echo "expected output is:"
echo $expected_output
echo ""
                  

# compare the outputs
if [ "$sync_output_no_time" = "$expected_output" ]; then
    echo "Output matches expected"
    exit 0
else
    echo "ERROR: Output doesn't match expected"
    echo $output
    exit 1
fi

