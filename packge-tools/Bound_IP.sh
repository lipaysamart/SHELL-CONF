#!/bin/bash
#####################
# author: Ethan
# email: lipaysamart@gmail.com
# usage: 在虚拟机初始化时，固定你机器的IP地址脚本。
# example：bash Bound_IP.sh 192.168.1.99 192.168.1.1
#####################

ip a >1.txt
IP=$1
GW=$2 
i=`awk '{print $2}' $PWD/1.txt  | awk 'NR==7{print}' | awk -F ':' '{print $1}'`
ADRES=/etc/sysconfig/network-scripts/ifcfg-$i
sed -i "s#ONBOOT=no#ONBOOT=yes#g" $ADRES
sed -i "s#dhcp#static#g" $ADRES
cat <<-EOF  >>$ADRES
IPADDR=$IP
NETMASK=255.255.255.0
GATEWAY=$GW
DNS1=233.5.5.5
DNS2=8.8.8.8
EOF
systemctl restart network
ping -c 1 www.baidu.com
rm -f $PWD/1.txt