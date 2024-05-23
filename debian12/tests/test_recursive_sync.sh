set -x

zelta sync -R apool bpool/Backups_Rd1_apool-backup

zfs list -r bpool/Backups_Rd1_apool-backup
