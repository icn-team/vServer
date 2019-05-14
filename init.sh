#!/bin/bash

VETH=($(ip link show | grep mtu | awk '{print $2}' | awk '{$0=substr($0,1,length($0)-1); print $0}'))

for i in "${VETH[@]}"
do
   if [[ $i == *"eth"* ]]
   then
       ip addr flush dev $i
       ethtool -K $i tx off rx off ufo off gso off gro off tso off
fi
done
/usr/bin/vpp -c /etc/hicn/super_startup.conf &
sleep 5
sysrepod
sysrepo-plugind
netopeer2-server
trap "kill -9 $$" SIGHUP SIGINT SIGTERM SIGCHLD
wait
