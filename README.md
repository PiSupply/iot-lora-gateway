# iot-lora-gateway

Note! This repository isn't updated as much now. We highly recommend using a Raspberry Pi and our pre built SD Card image for best results and reliability. Only basic support will be given.

# Installation
1. Login via SSH or console
2. Run the following command and the software will be all downloaded and compiled
```
curl -sSL https://raw.githubusercontent.com/PiSupply/iot-lora-gateway/release/iot-lora-installer | sudo python3

```

#Other SBC Requests
You are free to modify the code to adjust to use other boards however apart from Tinkerboard we are not providing any support for other boards. A Raspberry Pi with our newer SD Card Image is highly recommended.


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
