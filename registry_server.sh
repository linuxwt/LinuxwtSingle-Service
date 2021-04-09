#!/bin/bash

####docker私有镜像仓库服务端部署###### 
fw_status=$(systemctl status firewalld | grep active | wc -l)
[ ${fw_status} -eq 1 ] && { systemctl stop firewalld;systemctl disable firewalld;} || echo "firewalld is not running." 

[ ! -d "$(pwd)/registry" ] && mkdir registry || { mv registry registry.bak;mkdir registry;} 

cat <<EOF>> $(pwd)/docker-compose.yml
registry_linuxwt:
    restart: always
    image: registry:latest
    container_name: registry_linuxwt
    volumes:
        - ./registry:/var/lib/registry
        - /etc/localtime:/etc/localtime
        - /etc/timezone:/etc/timezone
    privileged: true
    ports:
       - "5000:5000"
EOF 

docker-compose up -d  
contain_status=$(docker ps -a | grep registry | grep Up | wc -l)
[ ${contain_status} -eq 1 ] && echo "repo is ok." || exit -1
