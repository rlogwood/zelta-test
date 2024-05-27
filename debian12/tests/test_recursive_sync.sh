set -x

set +e

dataset_arg="apool"

last_snapshot_name=$(find_last_snapshot_name $dataset_arg)

echo "last snapshot: $last_snapshot_name"

sync_output=$(zelta sync -R $dataset_arg bpool/Backups/"$dataset_arg"-backup)

zfs list -r bpool/Backups/apool-backup

#sync_output=$(zelta sync -sR $dataset_arg bpool/Backups/src-apool-backup)

echo "sync_output"
echo $sync_output

placeholder_output=$(cat <<'END'
replicating 1 streams
skipping dataset apool/treetop: snapshot {last_snapshot_name} does not exist
cannot mount '/bpool/Backups/apool-backup/treetop-backup': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/add': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/add/7': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/minus': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/minus/two': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/minus/two/one': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/minus/two/one/0': failed to create mountpoint: Read-only file system
cannot mount '/bpool/Backups/apool-backup/treetop-backup/minus/two/one/0/lift off': failed to create mountpoint: Read-only file system
1M sent, 34/34 streams received in {time} seconds
END
)

cmd="echo \"$placeholder_output\" | sed s/{last_snapshot_name}/"$last_snapshot_name"/g | sed 's/received in [0-9.]\+ seconds/received in {time} seconds/'"

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




