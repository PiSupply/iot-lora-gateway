#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install python3-dialog protobuf-compiler libprotobuf-dev libprotoc-dev automake libtool autoconf git pkg-config protobuf-c-compiler -y



rm -rf /opt/iotloragateway
mkdir -p /opt/iotloragateway
mkdir -p /opt/iotloragateway/dev
cd /opt/iotloragateway/dev

git clone https://github.com/PiSupply/lora_gateway.git
git clone https://github.com/PiSupply/paho.mqtt.embedded-c.git
git clone https://github.com/PiSupply/ttn-gateway-connector.git
git clone https://github.com/PiSupply/protobuf-c.git
git clone https://github.com/PiSupply/packet_forwarder.git
git clone https://github.com/PiSupply/iot-lora-gateway.git

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

cd /opt/iotloragateway/dev/iot-lora-gateway/

sudo mkdir /boot/iotloragateway
sudo mkdir /boot/iotloragateway/global_confs

sudo install -m 644 template_configs/EU-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_conf.json"
sudo install -m 644 template_configs/AS1-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
sudo install -m 644 template_configs/AS2-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
sudo install -m 644 template_configs/AU-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
sudo install -m 644 template_configs/EU-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
sudo install -m 644 template_configs/IN-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
sudo install -m 644 template_configs/KR-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
sudo install -m 644 template_configs/US-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"


sudo install -m 644 template_configs/local_conf.json "${ROOTFS_DIR}/boot/iotloragateway/"
sudo install -m 644 template_configs/iot-lora-gateway.service "${ROOTFS_DIR}/lib/systemd/system/"
sudo install -m 644 template_configs/iot-lora-gateway-reset.sh "${ROOTFS_DIR}/opt/iotloragateway/"

sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_spi 0

sudo systemctl daemon-reload
sudo systemctl enable iot-lora-gateway.service
