#!/bin/sh -x

path_contains_zelta_bin() {
    case "$PATH" in
        *"$ZELTA_BIN"*)
            echo "Path contains ZELTA_BIN: $ZELTA_BIN"
            return 1
            ;;
        *)
            echo "Path does not contain ZELTA_BIN: $ZELTA_BIN"
            return 0
            ;;
    esac
}


# if [ $(id -u) -ne 0 ]; then
#     echo "ERROR: you must run this script as root"
#     exit 1
# fi    

# rm -fr /usr/local/share/zelta
# rm -fr /usr/local/bin/zelta

USER_HOME=$(getent passwd $USER | cut -d: -f6)
echo "User's home directory is {$USER_HOME}"

ZELTA_REPO_ROOT="${ZELTA_REPO_ROOT:-$USER_HOME}"
ZELTA_REPO="$ZELTA_REPO_ROOT/zelta"

# if zelta repo not found, clone it
if [ ! -d "$ZELTA_REPO" ]; then
    git clone https://github.com/bellhyve/zelta.git $ZELTA_REPO
fi

ZELTA_INSTALL="$USER_HOME/.local/zelta"

export ZELTA_BIN=$ZELTA_INSTALL/bin
export ZELTA_SHARE=$ZELTA_INSTALL/share
export ZELTA_ETC=$ZELTA_INSTALL/etc
export ZELTA_DOC=$ZELTA_INSTALL/doc

#echo "PATH:$PATH"
#export PATH="$ZELTA_BIN:$PATH"

path_contains_zelta_bin
zelta_on_path=$?
if [ $zelta_on_path -eq 0 ]; then
    echo "adding ZELTA_BIN to path: $ZELTA_BIN"
    export PATH="$ZELTA_BIN:$PATH"
fi

#print "ON_PATH:$zelta_on_path"
#echo "PATH:$PATH"



# if [ "${PATH#*$ZELTA_BIN}" != "$ZELTA_BIN" ]; then
#   echo "The path contains ZELTA_BIN: $ZELTA_BIN"
# else
#     echo "The path does not contain ZELTA_BIN: $ZELTA_BIN"
# fi

curdir=$(pwd)
echo "curdir is $curdir"

cd $ZELTA_REPO
git pull
git checkout dev

rm -fr $ZELTA_INSTALL
./install.sh

cd $curdir

