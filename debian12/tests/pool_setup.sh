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
        print_error "Error occurred in pool_setup"
        print_error "* review your configuration in config.env"
    else
        echo "pool_setup successful"
    fi
}    

# Function to check if a ZFS pool exists
pool_exists() {
  POOL_NAME="$1"
  if zpool list -H -o name | grep -q "^${POOL_NAME}$"; then
    return 0  # Pool exists
  else
    return 1  # Pool does not exist
  fi
}

# Function to set a key-value pair
dict_set() {
  eval "dict_$1='$2'"
}

# Function to get the value for a key
dict_get() {
  eval "echo \${dict_$1}"
}


create_new_pools() {
    POOLS="$APOOL_NAME $BPOOL_NAME"

    dict_set $APOOL_NAME $APOOL_DISK
    dict_set $BPOOL_NAME $BPOOL_DISK

    for POOL_NAME in $POOLS; do
        echo "checking pool: $POOL_NAME"
        if  pool_exists "$POOL_NAME"; then
            echo "Destroying existing pool '$POOL_NAME'."
            set -x
            zpool destroy -f $POOL_NAME
            set +x
        fi

        echo "Creating new pool $POOL_NAME"
        disk=$(dict_get $POOL_NAME)
        echo "Disk is: $disk"
        set -x
        zpool create -f $POOL_NAME  $disk
        set +x        
    done
}


if [ -z "$APOOL_DISK$BPOOL_DISK" ]; then
    echo "ERROR: Define environment variables for APOOL_DISK and BPOOL_DISK"
    echo "for example APOOL_DISK=/dev/nvme?n1 where ? is your device #"
    exit 1
fi    

if [ $(id -u) -ne 0 ]; then
    echo "ERROR: you must run this script as root"
    exit 1
fi    

trap 'cleanup_function' EXIT $result

create_new_pools

zpool list
