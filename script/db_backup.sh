#!/bin/bash

dump_date=$(date +%y-%m-%d);

# ... ....
dump_dir="/backup/db_backup";
DB_user="root";
DB_pass="???";
DB_optimize_switch=0;

for database in `/usr/local/mysql/bin/mysqlshow -u ${DB_user} -p${DB_pass} | awk -F" " '{ print $2 }' | grep -v "^$" |grep -v "Databases"`
do
    echo "*------------------------------------------------------ *";
    echo "* ${database} START";
    echo "*------------------------------------------------------ *";

    if [ ! -d "${dump_dir}/${dump_date}/${database}" ]
    then
         mkdir -p ${dump_dir}/${dump_date}/${database};
    fi

    for table in `mysql -u ${DB_user} -p${DB_pass} -e"show tables" ${database} | grep -v "Tables_in_${database}" | grep -v "^$"`
    do
       if [ ${DB_optimize_switch} = "1" ]
       then
           mysql -u ${DB_user} -p${DB_pass} -e"optimize table ${table}" ${database}
       fi

       mysqldump -u ${DB_user} -p${DB_pass} --quick "${database}" ${table} > ${dump_dir}/${dump_date}/${database}/${table}.sql
       echo $table;
       echo "mysql -u ${DB_user} -p${DB_pass} $db < $table.sql" >> $dump_dir/$dump_date/$database/restore.sh
    done

    sleep 1;
done

echo "* ----------------------- - 1 DAY DELETE-------------------- *";
Old_Date=`/bin/date -d "15 day ago" +"%y-%m-%d"`;
rm -rf ${dump_dir}/${Old_Date};

#tar cvfz /backups/${dump_date}.tar ${dump_dir}/${dump_date};

echo "*----------------------------------------------------------- *";
echo "* BACKUP PATH : ${dump_dir}/${dump_date} ";
echo "*----------------------------------------------------------- *";
ls -asl ${dump_dir}/${dump_date};
exit 0;

#201031 추가
find /backup/db_backup/* -type d -mtime +30 -exec rm -rf {} \;
