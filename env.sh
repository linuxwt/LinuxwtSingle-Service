#!/bin/bash

sed -i 's/enforcing/disabled/g' /etc/selinux/config
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
systemctl stop firewalld && systemctl disable firewalld && systemctl daemon-reload
