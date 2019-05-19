#!/bin/bash

for i in $*
do
   ip addr flush dev $i
   ethtool -K $i tx off rx off ufo off gso off gro off tso off
done

/usr/bin/vpp -c /etc/hicn/super_startup.conf &
sleep 20
sysrepod
sysrepo-plugind
netopeer2-server
trap "kill -9 $$" SIGHUP SIGINT SIGTERM SIGCHLD
wait
