FROM  jenkins/jenkins:lts
MAINTAINER linuxwt <tengwanginit@gmail.com>

USER root

ENV prog /etc/profile
RUN chmod +x ${prog}


ADD ./apache-maven-3.5.4-bin.tar.gz /usr/local/maven

RUN echo "export MAVEN_HOME=/usr/local/maven/apache-maven-3.5.4" >> /etc/profile
RUN echo "export PATH=\${MAVEN_HOME}/bin:\$PATH" >> /etc/profile
