#!/bin/bash

# 下载cacti，并将其放入nginx的映射目录
wget https://www.cacti.net/downloads/cacti-1.1.38.tar.gz
mkdir -p /usr/local/Nginx/html
tar zvxf cacti-1.1.38.tar.gz
mv cacti-1.1.38 /usr/local/Nginx/html/cacti
