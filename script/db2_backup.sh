#!/bin/bash
#table 단위 backup

#setting
today=`date +%Y%m%d`
dump_time=`date +%Y%m%d-%H`
backup_dir=/backup/gif_db_backup
socket=/tmp/mysql.sock
#remote_path=??
logfile=/home/kthkdh13/log/dbdump/dump_$today.log

#database
database="??"
db_user="root"
db_pass="??"

if [ ! -d "${backup_dir}/${today}/${database}_${dump_time}" ]
then
	mkdir -p ${backup_dir}/${today}/${database}_${dump_time};
fi

echo "[$dump_time] : $database dump start.." >> $logfile
#echo " " >> $logfile

#db table backup (gif)
for table in `mysql -u${db_user} -p${db_pass} -S ${socket} -e "show tables" ${database} | grep -v "Tables_in_${database}"`
do
  mysqldump -u${db_user} -p${db_pass} --quick --single-transaction -S ${socket} "${database}" ${table} > ${backup_dir}/${today}/${database}_${dump_time}/${table}.sql

    echo "mysql -u${db_user} -p${db_pass} $database < $table.sql" >> ${backup_dir}/${today}/${database}_${dump_time}/restore.sh
	echo $table
	sleep 1
done

#rsync -avP ${backup_dir}/${today}/${database}_${dump_time}/ 115.165.177.219::suSync${remote_path}/${database}_${dump_time}/ >> $logfile
#rm -rf ${backup_dir}/${today}

echo "[$dump_time] : $database dump & copy finished.." >> $logfile
echo " " >> $logfile

# old log delete
find /home/kthkdh13/log/dbdump/*.log -type f -mtime +6 -exec rm -f {} \;
find ${backup_dir}/ -type d -mtime +6 -exec rm -rf {} \;
