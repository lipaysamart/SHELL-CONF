#!/bin/bash
#####################
# author: Ethan
# email: lipaysamart@gmail.com
# usage: 在虚拟机初始化时，固定你机器的IP地址脚本。
# example：bash Bound_IP.sh 192.168.1.99 192.168.1.1
#####################

for i in {1..254}
do
    ping -i -s 200 -c 1 ${1}.${i} &>/dev/null
    if [[ $? -eq 0 ]];then
        echo "${1}.${i}PING成功，网络通畅" >>/tmp/host_up.txt
    else
        echo "${1}.${i}失败，网络不通畅" >>/tmp/host_down.txt
    fi
done