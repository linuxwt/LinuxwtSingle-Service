#!/bin/bash

# 获取cacti服务器的ip
netcard=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg | grep -v lo)
card=${netcard//ifcfg-/}
ip_net=$(ip addr | grep $card | grep inet | awk '{print $2}')
ip=${ip_net//\/24/}

echo -n "please enter the ip and root password of host which you want to monitor->"
read client_ip passwd
[ -f /usr/bin/expect ] || yum -y install expect
client_config () {
/usr/bin/expect << EOF
set timeout 200
spawn scp  -o StrictHostKeyChecking=no $(pwd)/yum.sh snmp.sh ${client_ip}:/root
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${client_ip} -o StrictHostKeyChecking=no /root/yum.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${client_ip} -o StrictHostKeyChecking=no /root/snmp.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${client_ip} -o StrictHostKeyChecking=no sed -i 's/default/${ip}/g' /etc/snmp/snmpd.conf
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${client_ip} -o StrictHostKeyChecking=no ntpdate ${ip}
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${client_ip} -o StrictHostKeyChecking=no systemctl restart snmpd
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

client_config
