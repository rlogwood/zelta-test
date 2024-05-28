#!/bin/sh -x

set +e

# confirm the tree by log inspection
zfs list

dataset_arg="bpool/Backups/apool"

# perform backup
backup_output=$(zelta backup apool $dataset_arg)

#echo "backup_output:$backup_output"

last_snapshot_name=$(find_last_snapshot_name $dataset_arg)

echo "last_snapshot_name: $last_snapshot_name"

placeholder_output=$(cat <<'END'
source snapshot created: @{last_snapshot_name} replicating 27 streams 1M sent, 34/34 streams received in {time} seconds
END
)

#last_snapshot_name=$(last_snapshot_name)

cmd="echo \"$placeholder_output\" | sed s/{last_snapshot_name}/"$last_snapshot_name"/g | sed 's/received in [0-9.]\+ seconds/received in {time} seconds/'"

expected_output=$(eval $cmd)

backup_output_no_time=$(echo $backup_output | sed 's/received in [0-9.]\+ seconds/received in {time} seconds/')

echo "** last_snapshot_name is $last_snapshot_name"

echo "backup command output without time is:"
echo $backup_output_no_time
echo ""
echo "expected output is:"
echo $expected_output
echo ""
                  
                  
# compare the outputs
if [ "$backup_output_no_time" = "$expected_output" ]; then
    echo "Output matches expected"
    exit 0
else
    echo "ERROR: Output doesn't match expected"
    echo $output
    exit 1
fi

