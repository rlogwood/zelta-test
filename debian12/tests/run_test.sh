#!/bin/sh

cleanup_function() {
    result=$?
    set +x
    if [ $result -ne 0 ]; then
       echo "Error occurred in test $test_file"
       echo "Check logfile \"$test_log\", exit code was \"$result\""
    else
       echo "Successful test $test_file"
    fi
}    


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
echo "Running test file: \"$test_file\""

set -xe
trap 'cleanup_function' EXIT $result
. ./$test_file > $test_log 2>&1


# if we made it here, exit is clean
exit 0
