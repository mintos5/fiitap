#!/bin/bash
if [ $UID != 0 ]; then
	echo "ERROR: Not root user?"
	exit 1
fi
echo "installing openssl library"
apt-get update
apt-get install libssl-dev
echo "installing lora_gateway"
cd ./lora_gateway
make
make install
cd ..
echo "installing PacketConverter"
cd ./PacketConverter
./install.sh
cd ..
echo "all done to install systemd daemon run ./PacketConverter/install.sh daemon"
