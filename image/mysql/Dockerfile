FROM centos:7
MAINTAINER linuxwt <tengwanginit@gmail.com>

# 更换yum源
RUN yum -y install wget \
&& cd /etc/yum.repos.d \
&&  mv CentOS-Base.repo CentOS-Base.repo.bak \
&& wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&& mv CentOS7-Base-163.repo CentOS-Base.repo \
&&  yum makecache

RUN wget https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm \
&& rpm --import /etc/pki/rpm-gpg/RPM* \
&& rpm -Uvh  mysql80-community-release-el7-1.noarch.rpm

COPY repo /etc/yum.repos.d/mysql-community.repo 
RUN yum -y install mysql-community-server \
&& chown -R mysql:mysql /var/lib/mysql

ADD config.sql /tmp/config.sql
COPY start.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh

CMD  ["/tmp/start.sh"]
