FROM centos
MAINTAINER <tengwanginit@gmail.com>

RUN yum -y install wget \
&& cd /etc/yum.repos.d \
&&  mv CentOS-Base.repo CentOS-Base.repo.bak \
&& wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&& mv CentOS7-Base-163.repo CentOS-Base.repo \
&& yum makecache && yum -y update \ 
&& yum -y install python-setuptools \
&& wget https://pypi.python.org/packages/source/p/pip/pip-1.3.1.tar.gz --no-check-certificate \
&& tar -xzvf pip-1.3.1.tar.gz  \
&& cd pip-1.3.1 \
&& python setup.py install

RUN pip install shadowsocks

CMD ["/usr/bin/ssserver","-c","/etc/shadowsocks.json"] 
 


 

