#!/bin/sh -e 

# TODO: use $APOOL_NAME and $BPOOL_NAME everywhere

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
        print_error "Error occurred in run_all"
    fi
}    


trap 'cleanup_function' EXIT $result

# list of tests to run, file format is test_(test).sh
# using an array to control order of tests
TESTS="\
backup \
fallback \
match \
sync \
recursive_sync \
src_recursive_sync"

#TESTS="backup"

# initialize test environment
# NOTE: setup_test_env modifies environment, must be dotted
. ./setup_test_env.sh exit

if [ $? -ne 0 ]; then
    echo "ERROR: Test setup failed"
    exit 1
fi    


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
        print_error "ERROR:Test $TEST_NAME failed, check log."
        error_count=$((error_count + 1))
    fi
done


echo "Total errors: $error_count"
exit $error_count
