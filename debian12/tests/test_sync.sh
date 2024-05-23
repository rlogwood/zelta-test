set -x

zfs list bpool/Backups/apool

if [ $? -eq 1 ];  then
    "This test depends on test_backup.sh, please run it first"
    exit 1
fi   

zelta sync -c bpool/Backups/apool  bpool/temp/apool-backup

zfs list -r bpool/temp/apool-backup

zelta sync -R apool bpool/Backups_Rd1_apool-backup

zfs list -r bpool/Backups_Rd1_apool-backup

