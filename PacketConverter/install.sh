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
	echo "INFO: Locally installing to this folder:"
	mkdir -p debug
	cd ./debug
	#cmake -DCMAKE_BUILD_TYPE=Debug .. build with debug symbols
	cmake ..
	make
	make install
	cd ..
fi
if [ "$command" == "daemon" ]; then
  echo "WARNING: Installation should be done from PacketConverter folder by running ./install.sh daemon"
	echo "INFO: Installing daemon service:"
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
	echo "SUCCESS: Service successfully installed and is located at /lib/systemd/system/packet_converter.service"
	echo "INFO: To disable it, run as super user:"
	echo "  systemctl disable packet_converter.service"
	echo "INFO: In order to uninstall PacketConverter agent, run as super user:"
	echo "  ./install.sh clear"
fi
if [ "$command" == "clear" ]; then
	echo "INFO: Clearing all install files:"
	rm ./packet_converter
	rm -rf ./debug/
	systemctl disable packet_converter.service
	echo "SUCCESS: All PacketConverter files are cleaned and systemd daemon is disabled"
fi
