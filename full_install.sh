#!/bin/bash
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
