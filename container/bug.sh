#!/bin/bash

/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -uroot -plinuxwt123 mysql
