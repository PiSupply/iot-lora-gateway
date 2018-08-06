#!/bin/bash
echo "11" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio11/direction
echo "1" > /sys/class/gpio/gpio11/value
sleep 1
echo "0" > /sys/class/gpio/gpio11/value
cd /opt/iot-lora-gateway/
./mp_pkt_fwd
echo "11" >/sys/class/gpio/unexport
