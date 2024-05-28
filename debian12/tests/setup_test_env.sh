#!/bin/sh -e

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
        print_error "ERROR: Test Environment Setup Failed, review output and correct problem"
        echo "Exit code is \"$result\""
    else
        echo "Test environment setup successfully"
    fi
}    


install_latest_zelta() {
    # must be dotted, changes the PATH to include zelta bin
    . ./clean_zelta_install.sh
}

create_new_pools() {
    # fresh pools
    ./pool_setup.sh
}

create_new_tree() {
    # make fresh tree
    ./make-snap-tree.sh
}    

initialize_tests() {
    . ./config.env
    create_new_pools
    # setup environment fresh
    install_latest_zelta
    create_new_tree
}

trap 'cleanup_function' EXIT $result


if [ $(id -u) -ne 0 ]; then
    print_error "ERROR: you must run this script as root"
    exit 1
fi    

initialize_tests


# confirmation of pools and file systems
echo "** Perform visual confirmation of setup"

zpool list
zfs list

