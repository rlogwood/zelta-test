#!/bin/sh

print_error() {
  { set +x; } 2>/dev/null
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  echo "${RED}Error: $1${NC}" >&2
  { set -x; } 2>/dev/null
}

cleanup_function() {
    result=$?
    set +x 
    if [ $result -ne 0 ]; then
        print_error "Error occurred in test $test_file"
        print_error "Check logfile \"$test_log\", exit code was \"$result\""
    else
        echo "Successful test $test_file"
        echo ""
    fi
}    

find_last_snapshot_name() {
    dataset_name=$1
    entry=$2

    if [ -z "$entry" ]; then
        filter="tail -1"
    else
        filter="tail -$entry | head -1"
    fi

    #snapshots_cmd="zfs list -t snapshot -o name,creation -s creation -r $dataset_name | grep \"$dataset_name@\""

    #all_snapshots=$(eval $snapshots_cmd)
    
    cmd="zfs list -t snapshot -o name,creation -s creation -r $dataset_name | grep \"$dataset_name@\" | $filter | awk -F'@' '{print \$2}' | awk '{print \$1}'"

    #last_snapshot_cmd="echo $all_snapshots | grep  grep \"$dataset_name@\""
    
    #last_snapshot_name=$(eval $last_snapshot_cmd)
    last_snapshot_name=$(eval $cmd)

    echo $last_snapshot_name
}

#====================================================

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "No test name provided. Exiting."
    exit 1
fi


test_file="test_$1.sh"
test_log="logs/test_$1.log"

# Check if the test file exists
if [ ! -f "$test_file" ]; then
    echo "Test \"$1\" does not exist. Exiting."
    exit 1

fi


# If an argument is provided, continue with the script

trap 'cleanup_function' EXIT $result

echo "Running test file: \"$test_file\" $*"
set -xe
. ./$test_file $* > $test_log 2>&1
set +xe

# if we made it here, exit is clean
exit 0
