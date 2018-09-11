#!/bin/bash

#IOT LoRa Installer
#By Ryan Walmsley
#This file downloads the current software for the LoRa Gateway Packet Forwarder By Kersing and installs it on your Raspberry Pi
#At the same time it also enables SPI, Installs a service to automatically start it on boot, a configuration script and
#Sets the core clock to a fixed frequency which fixes bugs on Models 3B & 3B+

#This Software is designed to be run on a Vanilla installation of Raspbian! We cannot gaurantee that it will not break Other
#Software you are running on your Raspberry Pi.


##START
echo '''

  ___ ___ _____   _        ___         ___      _
 |_ _/ _ \_   _| | |   ___| _ \__ _   / __|__ _| |_ _____ __ ____ _ _  _
  | | (_) || |   | |__/ _ \   / _` | | (_ / _` |  _/ -_) V  V / _` | || |
 |___\___/ |_|   |____\___/_|_\__,_|  \___\__,_|\__\___|\_/\_/\__,_|\_, |
                                                                    |__/

This script will install the software required to get your Pi Supply
IoT Lora Gateway HAT Up and running with The Things Network

The script will automatically continue in 10 seconds. If you are not happy press Control + C to quit.
'''
sleep 10

##TODO
##We need to check which system this is running on

#Set variable model to 0 for rpi, 1 for tinkerboard, 2 for odroid c2. We don't need tosplit all RPi models
PLATFORM=cat /proc/device-tree/model
echo $PLATFORM


##Update apt repo list, upgrade any other packages and then install the required packages.
apt-get update
apt-get upgrade -y
apt-get install python3-dialog protobuf-compiler libprotobuf-dev libprotoc-dev automake libtool autoconf git pkg-config protobuf-c-compiler -y


#Delete all of the old software. This is fine as the configuration files are stored on the /boot partition
rm -rf /opt/iotloragateway
#Re-make directory structure
mkdir -p /opt/iotloragateway
mkdir -p /opt/iotloragateway/dev

#CD Into that folder
cd /opt/iotloragateway/dev

##Download all of the software required.
git clone https://github.com/PiSupply/lora_gateway.git
git clone https://github.com/PiSupply/paho.mqtt.embedded-c.git
git clone https://github.com/PiSupply/ttn-gateway-connector.git
git clone https://github.com/PiSupply/protobuf-c.git
git clone https://github.com/PiSupply/packet_forwarder.git
git clone https://github.com/PiSupply/iot-lora-gateway.git

#First lets compile the lora gateway driver library which provides the SPI Interface
cd /opt/iotloragateway/dev/lora_gateway/libloragw
##TODO
#Change the configuration file based on what system is being Used

#Compile the LoRa Gateway driver
make

##Move to the protobuf-c library and compile it
cd /opt/iotloragateway/dev/protobuf-c
./autogen.sh
./configure
make protobuf-c/libprotobuf-c.la
mkdir bin
#Install the library
./libtool install /usr/bin/install -c protobuf-c/libprotobuf-c.la `pwd`/bin
rm -f `pwd`/bin/*so*

#Move to the MQTT Embedded Library
cd /opt/iotloragateway/dev/paho.mqtt.embedded-c
make
make install

#Move ot the TTN Connector Library
cd /opt/iotloragateway/dev/ttn-gateway-connector
cp config.mk.in config.mk
make
#Copy it to /usr/lib directory for usage
cp /opt/iotloragateway/dev/ttn-gateway-connector/bin/libttn-gateway-connector.so /usr/lib

#Move to the packet forwarder itself
cd /opt/iotloragateway/dev/packet_forwarder/mp_pkt_fwd
#Compile the packet forwarder
make
#Copy this up one directory ready for the user to run
cp /opt/iotloragateway/dev/packet_forwarder/mp_pkt_fwd/mp_pkt_fwd /opt/iotloragateway/iot-lora-gateway

#Move to our directory with all of our template configs
cd /opt/iotloragateway/dev/iot-lora-gateway/
#Create folders on the SD Card's boot. Should get ignored if already existing.
mkdir /boot/iotloragateway
mkdir /boot/iotloragateway/global_confs

#Copy all of the regions template configuration files
install -m 644 template_configs/EU-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_conf.json"
install -m 644 template_configs/AS1-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
install -m 644 template_configs/AS2-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
install -m 644 template_configs/AU-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
install -m 644 template_configs/EU-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
install -m 644 template_configs/IN-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
install -m 644 template_configs/KR-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"
install -m 644 template_configs/US-global_conf.json "${ROOTFS_DIR}/boot/iotloragateway/global_confs"

#Copy over the template induvidual gateway file
install -m 644 template_configs/local_conf.json "${ROOTFS_DIR}/boot/iotloragateway/"
#Copy the service file which will automatically start the forwarder on boot
install -m 644 template_configs/iot-lora-gateway.service "${ROOTFS_DIR}/lib/systemd/system/"

#Copy the correct GPIO Reset script based on the board used
##TODO Detect which board and copy based on board used.
install -m 644 template_configs/iot-lora-gateway-reset.sh "${ROOTFS_DIR}/opt/iotloragateway/"

#If Raspberry Pi enable SPI Bus and set the core clock to
##TODO Only run this if Raspberry Pi
raspi-config nonint do_spi 0
##TODO Change core freq to core_freq=250


##Reload Systemctl daemon and enable the service
systemctl daemon-reload
systemctl enable iot-lora-gateway.service

#Symlink the configuration script so that it can be run from the terminal
echo '''
  ___ ___ _____   _        ___         ___      _
 |_ _/ _ \_   _| | |   ___| _ \__ _   / __|__ _| |_ _____ __ ____ _ _  _
  | | (_) || |   | |__/ _ \   / _` | | (_ / _` |  _/ -_) V  V / _` | || |
 |___\___/ |_|   |____\___/_|_\__,_|  \___\__,_|\__\___|\_/\_/\__,_|\_, |
                                                                    |__/

Congratulations the gateway software is now fully installed!

You need to edit the configuration file for your gateway to be setup which is located
at /boot/iotloragateway/

You can either do this using a text editor or run "iot-lora-configure" for our
wizard based editor.

After upon rebooting your Raspberry Pi your gateway should be up and running.

'''
