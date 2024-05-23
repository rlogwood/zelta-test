set -x

zfs list bpool/Backups/apool

if [ $? -eq 1 ];  then
    "This test depends on test_backup.sh, please run it first"
    exit 1
fi   

zelta match apool bpool/Backups/apool
