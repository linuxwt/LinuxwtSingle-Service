#!/bin/bash

installdocker()
{
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager  --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum -y install docker-ce
}
docker version
if [ $? -eq 127 ];then
        echo "we can install docker-ce"
        sleep 5
        installdocker
        docker version
        if [ $? -lt 127 ];then
                echo "the installation of docker-ce is ok."
		rpm -qa | grep docker | xargs rpm -e --nodeps 
                yum -y install docker-ce-18.03*
        else
                echo "the installation of docker-ce failed ,please reinstall"
                exit -1
        fi
else
        echo "docker have installed，pleae uninstall old version"
        sleep 5
        rpm -qa | grep docker | xargs rpm -e --nodeps
        docker version
        if [ $? -eq 127 ];then
                echo "old docker have been uninstalled and you can install docker-ce"
                sleep 5
		installdocker
		docker version
		if [ $? -lt 127 ];then
			echo "the installation of docker-ce is ok."
			rpm -qa | grep docker | xargs rpm -e --nodeps
		        yum -y install docker-ce-18.03*	
		else
			echo "the installation of docker-ce failed anad please reinstall."
			exit -1
		fi
	else
		echo "the old docker uninstalled conpletely and please uninstall again."
		exit -1
	fi
fi
systemctl start docker && systemctl enable docker && systemctl daemon-reload 
docker_version=$(docker version | grep "Version" | awk '{print $2}' | head -n 2 | sed -n '2p')
if [ $? -eq 0 ];then
	echo "docker start successfully and the version is ${docker_version}"
fi
# 配置docker加速拉取
echo {\"registry-mirrors\":[\"https://nr630v1c.mirror.aliyuncs.com\"]} > /etc/docker/daemon.json


# 安装常用工具
yum -y install lrzsz && yum -y install openssh-clients && yum -y install telnet && yum -y install rsync 

# 防火墙配置
setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux

systemctl restart docker
