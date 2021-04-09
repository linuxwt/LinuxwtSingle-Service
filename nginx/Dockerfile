FROM centos:7
MAINTAINER linuxwt <tengwanginit@gmail.com>

# 更换163源
RUN yum -y install wget
RUN cd /etc/yum.repos.d \
&&  mv CentOS-Base.repo CentOS-Base.repo.bak \
&& wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&& mv CentOS7-Base-163.repo CentOS-Base.repo
RUN yum makecache && yum -y update


# 配置相关的依赖
RUN yum -y install gcc gcc-c++
RUN yum -y install pcre*
RUN yum -y install zlib*
RUN yum -y install make

RUN yum -y install pango*
RUN yum -y install perl-devel
RUN yum -y install libxml2 libxml2-devel

# 将宿主机解压后的源码包添加进来,然后编译安装
ADD ./nginx-1.15.5 /tmp
RUN mkdir -p /usr/local/Nginx
RUN cd /tmp  && ./configure --prefix=/usr/local/Nginx --with-poll_module --with-http_stub_status_module && make && make install
RUN echo "daemon off;" >> /usr/local/Nginx/conf/nginx.conf

#RUN cd /tmp && wget https://oss.oetiker.ch/rrdtool/pub/rrdtool-1.7.0.tar.gz && tar zvxf rrdtool-1.7.0.tar.gz
#WORKDIR /tmp/rrdtool-1.7.0
#RUN ./configure --prefix=/usr/local/rrdtool && make && make install
#RUN yum install -y net-snmp net-snmp-devel  net-snmp-libs  net-snmp-perl net-snmp-utils mrtg

expose 80

CMD ["/usr/local/Nginx/sbin/nginx"]

