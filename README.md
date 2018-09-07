# iot-lora-gateway
Overall Build Satus:
[![Build Status](https://jenkins.pi-supply.com/job/iot-lora-gateway/badge/icon)](https://jenkins.pi-supply.com/job/iot-lora-gateway/)

Github repo for some of our LoRa Gateway HAT Files for different tasks. See below for a detailed description.

You can either setup your gateway by using the one line installer script on Raspbian or instead, use our pre-made SD card image which has all of this already included.




# Files Included
### iot-lora-installer
This is our one line installer that will install the following software.
* lora_gateway - The drivers that are used to communicate with the radio module itself, this fork has it pre-configured for Raspberry Pi. - https://github.com/PiSupply/lora_gateway.git
* paho.mqtt.embedded - Eclipse Paho MQTT C/C++ Library - https://github.com/PiSupply/paho.mqtt.embedded-c.git
* ttn-gateway-connector - Embedded C Library for Things Network Gateways to connect to TTN - https://github.com/PiSupply/ttn-gateway-connector.git
* protobuf-c - C Implementation of the Google Protocol Buffers - https://github.com/PiSupply/protobuf-c.git
* mp_pkt_fwd - The Packet Forwarder itself, this is slightly tweaked so that it stores the configuration files in a folder on the boot partition of your Raspberry Pi allowing configuration changes to be made on any computer without having to use SSH. - https://github.com/PiSupply/packet_forwarder.git

### iot-lora-configure
Our configuration script for the software, this will configure the SPI & Clocks on the Raspberry Pi and allow the user to configure the gateway's name, description, region and servers using a simple interface. Also compatible with our gateway image.

### Systemd template
Our template for systemd that will automatically start the packet forwarder installed by our installer. Also used in our pre-made SD card image.

### Reset script
A basic bash script to reset the concentrator, required by our systemd template to automatically launch on boot.

### Reset RPi script
A little script that should reset the Raspberry Pi back to default settings. Used primarily for our jenkins build server.

## Contributing to this repo
Please make sure any changes are made to code are done from the master branch and not the release branch. The release branch is only for once it has passed compiling on the boards we are testing on.

If you have an SBC you wish to use which isn't in our supported list then create an issue for it with the correct tag for board requests. Even if it does work with another board doing this means we can document it.

##Automated Testing Status

**Raspberry Pi B+**
[![Build Status](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=Raspberry%20Pi%20B+/badge/icon)](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=Raspberry%20Pi%20B+/)

Running Raspbian Lite 2018-06-27-stretch


**Raspberry Pi 3B+**
[![Build Status](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=Raspberry%20Pi%203B+/badge/icon)](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=Raspberry%20Pi%203B+/)

Running Raspbian Lite 2018-06-27-stretch

**Asus Tinkerboard S2**
[![Build Status](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=ASUS%20Tinkerboard%20S/badge/icon)](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=ASUS%20Tinkerboard%20S/)

Running Armbian 5.59 Ubuntu 18.04 4.14

**ODroid C2**
[![Build Status](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=Odroid%20C2/badge/icon)](https://jenkins.pi-supply.com/job/iot-lora-gateway/SBCs=Odroid%20C2/)

Running ODroid's Ubuntu 18.04 Minimal 20180626
