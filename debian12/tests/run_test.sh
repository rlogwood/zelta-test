#!/bin/sh

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

./$test_file > $test_log 2>&1
result=$?
echo "Check logfile \"$test_log\", exit code was \"$result\""

exit $result
