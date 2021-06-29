#!/bin/bash

find /usr/local/apache-2.4.46/logs/*.log -type f -mtime +6 -exec rm -f {} \;
