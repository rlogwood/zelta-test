#!/bin/sh

echo "You must be root to run this!"

../../clean_zelta_install.sh

# Define the tests glob pattern
GLOB_PATTERN="test_*.sh"

# error count intialize
error_count=0

# Iterate over each file matching the glob pattern
for FILE in $GLOB_PATTERN; do
    # Check if there are no matching files
    if [ "$FILE" = "$GLOB_PATTERN" ]; then
        echo "No files matching the pattern were found."
        exit 1
    fi

    TEST_NAME="${FILE#*_}"
    TEST_NAME="${TEST_NAME%.sh}"

    # Run test for each file
    echo "Running test $TEST_NAME from file $FILE"
    ./run_test.sh $TEST_NAME

    if [ $? -ne 0 ]; then
        echo "ERROR:Test $TEST_NAME failed, check log."
        error_count=$((error_count + 1))
    fi
done



echo "Total errors: $error_count"
exit $error_count

