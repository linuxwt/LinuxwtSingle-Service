#!/bin/bash

mysqld --initialize-insecure > /dev/null &&
mysqld  &
sleep 5
mysql < /tmp/config.sql
sleep 5
ps -wef | grep mysql | grep -v grep | awk '{print $2}' | xargs kill -9
mysqld
