#!/bin/bash
#####################
# author: Ethan
# email: lipaysamart@gmail.com
# usage: 监控网路丢包率和延迟 -s 是一个ping包的大小 -W 是延迟timeout -c 是发生多少数据包。
# example：
#####################
#ping发包数
c_times=100
#IP列表数组，多IP定义（ 10.20.30.4  40.30.20.10 ） 
ip_arr=( 172.20.3.226 )
for (( i = 0; i < ${#ip_arr[@]}; ++i ))
 do
         result=`timeout 16 ping -q -A -s 200 -W 250 -c $c_times   ${ip_arr[i]}|grep transmitted|awk '{print $6,$10}'`
         if [ -z "$result" ]
         then
               value_lostpk=101
               value_rrt=1000
               echo "drop_packge ${value_lostpk}" | curl --data-binary @- http://127.0.0.1:9091/metrics/job/ping/instance/${ip_arr[i]}
               echo "current_time  ${value_rrt}" | curl --data-binary @- http://127.0.0.1:9091/metrics/job/ping/instance/${ip_arr[i]}
         else
               lostpk=$(echo $result|awk '{print $1}')
               rrt=$(echo $result|awk '{print $2}')
               value_lostpk=$(echo $lostpk | sed 's/%//g')
               value_rrt=$(echo $rrt |sed 's/ms//g')
               #value_rrt=$(($value_rrt/$c_times))
               value_rrt=$(printf "%.5f" `echo "scale=5;$value_rrt/$c_times"|bc`)
               echo "drop_packge ${value_lostpk}" | curl --data-binary @- http://127.0.0.1:9091/metrics/job/ping/instance/${ip_arr[i]}
               echo "current_time ${value_rrt}" | curl --data-binary @- http://127.0.0.1:9091/metrics/job/ping/instance/${ip_arr[i]}
         fi
         echo  ${ip_arr[i]}"==="$value_lostpk"==="$value_rrt
 done
