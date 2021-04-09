#!/bin/bash

FROM centos:7
MAINTAINER linuxwt <tengwanginit@gmail.com>

# 更换yum源
RUN yum -y install wget
RUN cd /etc/yum.repos.d \
&&  mv CentOS-Base.repo CentOS-Base.repo.bak \
&& wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&& mv CentOS7-Base-163.repo CentOS-Base.repo
RUN yum makecache && yum -y update
RUN yum -y install gcc gcc-c++ make


RUN groupadd redis && useradd -g redis redis

ADD redis-4.0.11.tar.gz /usr/local
RUN mv /usr/local/redis-4.0.11 /usr/local/redis

WORKDIR /usr/local/redis
RUN make

RUN mkdir /data && chown -R redis:redis /data
WORKDIR /data

CMD ["/usr/local/redis/src/redis-server","/usr/local/redis/redis.conf"]


