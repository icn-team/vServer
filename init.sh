#!/bin/bash

echo "Configure VPP"
if [ -n "$DPDK" ]
then
    DPDK_BLOCK="dpdk { $(echo $DPDK | tr -d '"') }"
fi

if [ -z "$NUM_BUFFER" ]
then
    NUM_BUFFER=16384
fi

if [ -z "$PIT_SIZE" ]
then
    PIT_SIZE=131072
fi

if [ -z "$CS_SIZE" ]
then
    CS_SIZE=4096
fi

if [ -z "$CS_RESERVED_APP" ]
then
    CS_RESERVED_APP=20
fi

sed -e "s/DPDK/$DPDK_BLOCK/g" \
    -e "s/NUM_BUFFER/$NUM_BUFFER/g" \
    -e "s/PIT_SIZE/$PIT_SIZE/g" \
    -e "s/CS_SIZE/$CS_SIZE/g" \
    -e "s/CS_RESERVED_APP/$CS_RESERVED_APP/g" \
    /tmp/startup_template.conf > /etc/vpp/startup.conf

echo "Run vpp"
/usr/bin/vpp -c /etc/vpp/startup.conf
