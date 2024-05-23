set -x

zelta sync -sR apool bpool/Backups_sRd1_apool-backup

zfs list -r bpool/Backups_Rd1_apool-backup

