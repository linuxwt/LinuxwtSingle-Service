#!/bin/bash

yum -y install bind-utils bind bind-devel
cp /etc/named.conf /etc/named.conf-bak

netcard=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg | grep -v lo)
card=${netcard//ifcfg-/}
ip_net=$(ip addr | grep ens33 | grep inet | awk '{print $2}')
ip=${ip_net//\/24/}
a=$(echo $ip | awk -F '.' '{print $1}')
b=$(echo $ip | awk -F '.' '{print $2}')
c=$(echo $ip | awk -F '.' '{print $3}')
net1="$a.$b.$c"
net2="$c.$b.$a"

master_ip=$(cat ip.txt | grep master | awk '{print $1}')
slave_ip=$(cat ip.txt | grep slave | awk '{print $1}')
sub_ip=$(cat ip.txt | grep sub | awk '{print $1}')
domain=$(cat ip.txt | tail -n 1)

master_num=${master_ip:10:3}
slave_num=${slave_ip:10:3}
sub_num=${sub_ip:10:3}

###主配置文件###
>/etc/named.conf
cat <<EOF>> //etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//
// See the BIND Administrator's Reference Manual (ARM) for details about the
// configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html

options {
        listen-on port 53 { $slave_ip;127.0.0.1; };
//      listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
        allow-query     { any; };
        masterfile-format text;
        /* 
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable 
           recursion. 
         - If your recursive DNS server has a public IP address, you MUST enable access 
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification 
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface 
        */
        recursion yes;

//      dnssec-enable yes;
        dnssec-validation yes;

        /* Path to ISC DLV key */
//      bindkeys-file "/etc/named.root.key";

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

###编辑正向区域配置文件###
cat <<EOF>> /etc/named.rfc1912.zones
zone "$domain" IN {
        type slave;
        masters { $master_ip;};
        file "slaves/${domain}.zone";
//        allow-update { none; };
};

zone "$net2.in-addr.arpa" IN {
        type slave;
        masters { $master_ip;};
        file "slaves/${net1}.zone";
//      allow-update { none; };
};
EOF
rndc reload
systemctl enable named
