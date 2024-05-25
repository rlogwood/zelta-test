#!/bin/sh -xe


echo "You must be root to run this!"


cleanup_function() {
    result=$?
    set +x
    if [ $result -ne 0 ]; then
        echo "ERROR: Test Environment Setup Failed, review output and correct problem"
        echo "Exit code is \"$result\""
    else
        echo "Test environment setup successfully"
    fi
}    


install_latest_zelta() {
    ../../clean_zelta_install.sh    
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
    # setup environment fresh
    install_latest_zelta
    create_new_pools
    create_new_tree
}


trap 'cleanup_function' EXIT $result

initialize_tests


# confirmation of pools and file systems
echo "** Perform visual confirmation of setup"

zpool list
zfs list

 
