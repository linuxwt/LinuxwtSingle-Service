#!/bin/bash

[ -f /usr/bin/expect ] || yum -y install expect
dns_deploy () {
/usr/bin/expect << EOF
set timeout 200
spawn scp  -o StrictHostKeyChecking=no $(pwd)/yum.sh slave.sh ip.txt env.sh ${slave_ip}:/root
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${slave_ip} -o StrictHostKeyChecking=no /root/yum.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${slave_ip} -o StrictHostKeyChecking=no /root/env.sh && yum -y install ntpdate
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF


/usr/bin/expect << EOF
set timeout 200
spawn ssh ${slave_ip} -o StrictHostKeyChecking=no ntpdate ${master_ip}
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${slave_ip} -o StrictHostKeyChecking=no /root/slave.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${slave_ip} -o StrictHostKeyChecking=no systemctl restart named
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

slave_ip=$(cat ip.txt | grep slave | awk '{print $1}')
master_ip=$(cat ip.txt | grep master | awk '{print $1}')
passwd=$(cat ip.txt | grep slave | awk '{print $2}')
$(pwd)/yum.sh && $(pwd/env.sh) && $(pwd)/ntp.sh && $(pwd)/master.sh && dns_deploy
