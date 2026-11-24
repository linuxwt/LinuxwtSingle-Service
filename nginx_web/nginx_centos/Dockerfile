FROM centos:7
MAINTAINER linuxwt <tengwanginit@gmail.com>

# 更换yum源
RUN yum -y install wget
RUN cd /etc/yum.repos.d \
&&  mv CentOS-Base.repo CentOS-Base.repo.bak \
&& wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&& mv CentOS7-Base-163.repo CentOS-Base.repo
RUN yum makecache && yum -y update

# 安装nginx,此处使用yum安装
RUN yum -y install epel-release \
&& yum -y install nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# 为了能够在容器里就像在宿主机上一样使用各种linux命令，安装基础依赖
RUN yum -y install gcc gcc-c++
RUN yum -y install net-tools

CMD ["/usr/sbin/nginx"]
