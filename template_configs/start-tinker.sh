#!/bin/bash
echo "178" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio167/direction
echo "1" > /sys/class/gpio/gpio167/value
sleep 1
echo "0" > /sys/class/gpio/gpio167/value
