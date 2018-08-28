# iot-lora-gateway
Github repo for some of our LoRa Gateway HAT Files for different tasks. See below for a detailed description.

You can either setup your gateway by using the one line installer script on Raspbian or instead, use our pre-made SD card image which has all of this already included.


# Files Included
### iot-lora-installer
This is our one line installer that will install the following software.
* lora_gateway - The drivers that are used to communicate with the radio module itself, this fork has it pre-configured for Raspberry Pi. - https://github.com/PiSupply/lora_gateway.git
* Software 2 - - https://github.com/kersing/paho.mqtt.embedded-c.git
* Software 3 - - https://github.com/kersing/ttn-gateway-connector.git
* Software 4 - - https://github.com/kersing/protobuf-c.git
* mp_pkt_fwd - The Packet Forwarder itself, this is slightly tweaked so that it stores the configuration files in a folder on the boot partition of your Raspberry Pi allowing configuration changes to be made on any computer without having to use SSH. - https://github.com/PiSupply/packet_forwarder.git

### iot-lora-configure
Our configuration script for the software, this will configure the SPI & Clocks on the Raspberry Pi and allow the user to configure the gateway's name, description, region and servers using a simple interface. Also compatible with our gateway image.

###Systemd template
Our template for systemd that will automatically start the packet forwarder installed by our installer. Also used in our pre-made SD card image.

###Reset script
A basic bash script to reset the concentrator, required by our systemd template to automatically launch on boot.
