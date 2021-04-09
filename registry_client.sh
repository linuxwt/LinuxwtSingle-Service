#!/bin/bash

####该脚本需要放在客户端#####
####serverip为服务端地址####
echo { \"registry-mirrors\": [ \"https://registry.docker-cn.com\"],\"insecure-registries\": [ \"serverip:5000\"]} > /etc/docker/daemon.json
