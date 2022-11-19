#!/bin/bash
if [ $UID != 0 ]; then
	echo "ERROR: Not root user?"
	exit 1
fi
echo "INFO: Installing openssl library"
apt-get update
apt-get install libssl-dev
echo "INFO: Installing lora_gateway driver"
cd ./lora_gateway
make
make install
cd ..
echo "INFO: Installing PacketConverter, a LoRa@FIIT access point agent"
cd ./PacketConverter
./install.sh
cd ..
echo "SUCCESS: All done"
echo "INFO: To install systemd daemon, run './install.sh daemon' from PacketConverter sub-folder"
