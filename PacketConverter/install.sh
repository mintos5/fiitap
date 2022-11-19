#!/bin/bash
# Check root user
if [ $UID != 0 ]; then
    echo "ERROR: Not root user?"
    exit 1
fi
# Set what to do
command="default"
if [ "$#" -ge 1 ]; then
	if [ "$1" == "daemon" ] || [ "$1" == "clear" ]; then
    command=$1
	fi
fi

# do stuff
if [ "$command" == "default" ]; then
	echo "Locally installing to this folder:"
	mkdir -p debug
	cd ./debug
	#cmake -DCMAKE_BUILD_TYPE=Debug .. build with debug symbols
	cmake ..
	make
	make install
	cd ..
fi
if [ "$command" == "daemon" ]; then
	echo "Installing daemon service:"
	touch /lib/systemd/system/packet_converter.service
	echo "[Unit]" > /lib/systemd/system/packet_converter.service
	echo "Description=PacketConverter daemon" > /lib/systemd/system/packet_converter.service
	echo "[Service]" >> /lib/systemd/system/packet_converter.service
	echo "WorkingDirectory=`pwd`" >> /lib/systemd/system/packet_converter.service 
	echo "ExecStart=`pwd`/start.sh" >> /lib/systemd/system/packet_converter.service
	echo "SyslogIdentifier=packet_converter" >> /lib/systemd/system/packet_converter.service
	echo "Restart=always" >> /lib/systemd/system/packet_converter.service
	echo "RestartSec=5" >> /lib/systemd/system/packet_converter.service
	echo "[Install]" >> /lib/systemd/system/packet_converter.service
	echo "WantedBy=multi-user.target" >> /lib/systemd/system/packet_converter.service
	systemctl daemon-reload
	systemctl enable packet_converter.service
	echo "Service successfully installed and is located at /lib/systemd/system/packet_converter.service"
	echo "To disable it, run as super user:"
	echo "  systemctl disable packet_converter.service"
fi
if [ "$command" == "clear" ]; then
	echo "Clearing all install files:"
	rm ./packet_converter
	rm -rf ./debug/
	systemctl disable packet_converter.service
fi
