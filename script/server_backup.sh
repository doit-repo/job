#!/bin/bash

export LANG=en
dayno="`date '+%j'`"
daybak="`expr $dayno % 30`"
backup_dir="/backup/sync/sync_$daybak"

function sync_bak {
  from=$1
  to=$2
  if [ ! -d "$to" ] ; then mkdir -p $to ; fi
  rsync -avz --delete $from $to
}

## 7일간 백업
rm -f /backup/sync/today
ln -s ${backup_dir}.tar.gz /backup/sync/today
sync_bak /usr/local/ $backup_dir/usr-local/
sync_bak /etc/ $backup_dir/etc/
sync_bak /root/ $backup_dir/root/
sync_bak /var/ $backup_dir/var/
sync_bak /home/ $backup_dir/home/
tar czvfp ${backup_dir}.tar.gz $backup_dir
rm -rf ${backup_dir}
touch ${backup_dir}.tar.gz

chown kthkdh13.users ${backup_dir}.tar.gz
