#!/bin/bash

export date="`date '+%Y-%m-%d %H:%M'`"
export date1="`date '+%Y-%m-%d'`"

echo "[ DATE : $date Disk Stat ]" > /root/disk_info/$date1\_archive.txt

smartctl -a /dev/sda | grep "Non-medium error count" >> /root/disk_info/$date1\_archive.txt
sleep 1
smartctl -a /dev/sda | grep "Non-medium error count" >> /root/disk_info/$date1\_archive.txt

