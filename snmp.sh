#!/bin/bash

yum -y install net-snmp net-snmp-devel
systemctl start snmpd
systemctl enable snmpd 
systemctl stop firewalld
systemctl daemon-reload

>/etc/snmp/snmpd.conf
cat <<EOF>>  /etc/snmp/snmpd.conf
com2sec notConfigUser  default    public
group   notConfigGroup v1           notConfigUser
group   notConfigGroup v2c           notConfigUser
view    systemview    included   .1.3.6.1.2.1.1
view    systemview    included   .1.3.6.1.2.1.25.1.1
access  notConfigGroup ""      any       noauth    exact  all none none
view all included .1 80
syslocation Unknown (edit /etc/snmp/snmpd.conf)
syscontact Root <root@localhost> (configure /etc/snmp/snmp.local.conf)
dontLogTCPWrappersConnects yes
EOF

yum -y install ntpdate

