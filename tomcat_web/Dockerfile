FROM centos:7
MAINTAINER linuxwt <tengwanginit@gmail.com>

# 更换yum源
RUN yum -y install wget
RUN cd /etc/yum.repos.d \
&&  mv CentOS-Base.repo CentOS-Base.repo.bak \
&& wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&& mv CentOS7-Base-163.repo CentOS-Base.repo
RUN yum makecache && yum -y update

# 安装依赖
RUN yum -y install gcc gcc-c++
RUN yum -y install net-tools

# 环境变量刷新
ENV prog /etc/profile
RUN chmod +x ${prog}

# 安装JDK
ADD jdk-8u192-linux-x64.tar.gz /usr/local/java
RUN echo "export JAVA_HOME=/usr/local/java/jdk1.8.0_192" >> /etc/profile
RUN echo "export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile
RUN echo "export PATH=\${JAVA_HOME}/bin:\$PATH" >> /etc/profile


# 安装tomcat
ADD apache-tomcat-8.5.37.tar.gz /tmp
RUN mv /tmp/apache-tomcat-8.5.37 /usr/local/tomcat
RUN echo "export JAVA_HOME=/usr/local/java/jdk1.8.0_192" >> /usr/local/tomcat/bin/setclasspath.sh
RUN echo "export JRE_HOME=/usr/local/java/jdk1.8.0_192/jre" >> /usr/local/tomcat/bin/setclasspath.sh

CMD ["/usr/local/tomcat/bin/catalina.sh","run"]
