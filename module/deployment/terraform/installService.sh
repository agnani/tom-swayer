#!/bin/bash

TAB="    "

# Make sure we are running script as root.
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  echo
  echo "${TAB}sudo ./installService.sh"
  echo
  exit 1
fi

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ApplicationName="my-project"
JarFile=""${ApplicationName}"-1.0.0.jar"
ServiceName="${ApplicationName}"
USER="tomsawyer"

echo "Installing Java 17."
yum update -y
yum install -y java-17-amazon-corretto.x86_64

if ! id "$USER" >/dev/null 2>&1; then
	echo "Creating user $USER to run the service"
	adduser $USER --system --shell /sbin/nologin
fi

chown -R $USER:$USER $ScriptDir/..
chmod 500 $ScriptDir/$JarFile

echo "Creating service $ServiceName."
if [ -f /usr/bin/systemctl ]; then

	if [ ! -f /etc/systemd/system/$ServiceName.service ]; then

		touch /etc/systemd/system/$ServiceName.service
		echo "[Unit]" > /etc/systemd/system/$ServiceName.service
		echo "Description="${ServiceName}" service created using Tom Sawyer Perspectives." >> /etc/systemd/system/$ServiceName.service
		echo "After=syslog.target" >> /etc/systemd/system/$ServiceName.service
		echo "StartLimitIntervalSec=0" >> /etc/systemd/system/$ServiceName.service
		echo "" >> /etc/systemd/system/$ServiceName.service

		echo "[Service]" >> /etc/systemd/system/$ServiceName.service
		echo "WorkingDirectory=$ScriptDir" >> /etc/systemd/system/$ServiceName.service
		echo "SyslogIdentifier=$ServiceName" >> /etc/systemd/system/$ServiceName.service
		echo "User=$USER" >> /etc/systemd/system/$ServiceName.service
		echo "Group=$USER" >> /etc/systemd/system/$ServiceName.service
		echo "ExecStart=/usr/bin/java -Xms512m -Xmx700m -Dspring.index.ignore=true -Djava.security.egd=file:/dev/./urandom -Duser.home=$ScriptDir -jar $ScriptDir/$JarFile" >> /etc/systemd/system/$ServiceName.service
		echo "SuccessExitStatus=143" >> /etc/systemd/system/$ServiceName.service
		echo "Restart=on-failure" >> /etc/systemd/system/$ServiceName.service
		echo "RestartSec=5" >> /etc/systemd/system/$ServiceName.service
		echo "" >> /etc/systemd/system/$ServiceName.service

		echo "[Install]" >> /etc/systemd/system/$ServiceName.service
		echo "WantedBy=multi-user.target" >> /etc/systemd/system/$ServiceName.service
		echo "" >> /etc/systemd/system/$ServiceName.service

	fi

	if [ ! -f $ScriptDir/uninstallService.sh ]; then

		touch $ScriptDir/uninstallService.sh

		echo "systemctl stop $ServiceName.service" > $ScriptDir/uninstallService.sh
		echo "systemctl disable $ServiceName.service" >> $ScriptDir/uninstallService.sh
		echo "rm /etc/systemd/system/$ServiceName.service" >> $ScriptDir/uninstallService.sh
		echo "systemctl daemon-reload" >> $ScriptDir/uninstallService.sh
		echo "systemctl reset-failed" >> $ScriptDir/uninstallService.sh

    chown $USER:$USER $ScriptDir/uninstallService.sh
		chmod u+x $ScriptDir/uninstallService.sh

	fi

	# Directory for application generated data file.
	if [ ! -d "/var/lib/$ServiceName" ]; then
		mkdir /var/lib/$ServiceName
		chown $USER:$USER /var/lib/$ServiceName
	fi

	systemctl enable $ServiceName.service

  echo
	echo "To Start the $ServiceName service now type:"
	echo
	echo "${TAB}sudo systemctl start $ServiceName"
	echo
fi
