#!/bin/bash

apt update
apt upgrade
apt install python3-dialog protobuf-compiler libprotobuf-dev libprotoc-dev automake libtool autoconf git



rm -rf /opt/iotloragateway
mkdir -p /opt/iotloragateway
mkdir -p /opt/iotloragateway/dev
cd /opt/iotloragateway/dev

git clone https://github.com/PiSupply/lora_gateway.git
git clone https://github.com/kersing/paho.mqtt.embedded-c.git
git clone https://github.com/kersing/ttn-gateway-connector.git
git clone https://github.com/kersing/protobuf-c.git
git clone https://github.com/PiSupply/packet_forwarder.git

cd /opt/iotloragateway/dev/lora_gateway/libloragw
make

cd /opt/iotloragateway/dev/protobuf-c
./autogen.sh
./configure
make protobuf-c/libprotobuf-c.la
mkdir bin
./libtool install /usr/bin/install -c protobuf-c/libprotobuf-c.la `pwd`/bin
rm -f `pwd`/bin/*so*

cd /opt/iotloragateway/dev/paho.mqtt.embedded-c
make
make install
echo "TTN Connector"
cd /opt/iotloragateway/dev/ttn-gateway-connector
cp config.mk.in config.mk
make
cp /opt/iotloragateway/dev/ttn-gateway-connector/bin/libttn-gateway-connector.so /usr/lib
echo "Packet Forwarder"
cd /opt/iotloragateway/dev/packet_forwarder/mp_pkt_fwd
make
cp /opt/iotloragateway/dev/packet_forwarder/mp_pkt_fwd/mp_pkt_fwd /opt/iotloragateway/iot-lora-gateway

systemctl daemon-reload
systemctl enable iot-lora-gateway.service
