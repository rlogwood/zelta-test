#!/bin/sh

# list of tests to run, file format is test_(test).sh
# using an array to control order of tests
TESTS="\
backup \
fallback \
match \
sync \
recursive_sync \
src_recursive_sync"

# initialize test environment
. ./setup_test_env.sh

# error count intialize
error_count=0

# clear all logs
rm -f ./logs/*.log

# Iterate over each file matching the glob pattern
for TEST_NAME in $TESTS; do
    echo "$TEST"
    FILE="test_$TEST_NAME.sh"

    # Run test 
    echo "Running test $TEST_NAME from file $FILE"
    ./run_test.sh $TEST_NAME

    if [ $? -ne 0 ]; then
        echo "ERROR:Test $TEST_NAME failed, check log."
        error_count=$((error_count + 1))
    fi
done


echo "Total errors: $error_count"
exit $error_count

