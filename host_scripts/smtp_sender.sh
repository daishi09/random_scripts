#####################################################################################################
# Script_Name : smtp_sender.sh
# Description : simulates smtp traffic with custom message
# Date : November 2019
####################################################################################################


# ----- Create a script to run smtp_sender.py while sending errors to /dev/null to avoid filling logs
cat > /root/py_autorun.sh <<"__EOF__"
#!/bin/sh
while [ true ]
do
  /usr/bin/python /root/smtp_receiver.py 2>/dev/null
done
__EOF__

chmod +x /root/py_autorun.sh


# ----- Create service to autorun python script for smtp sender
cat > /lib/systemd/system/py_autorun.service <<"__EOF__"
[Unit]
Description=Python Autorun Service

After=network.target
StartLimitInterval=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/bin/bash /root/py_autorun.sh

[Install]
WantedBy=multi-user.target
__EOF__

systemctl start py_autorun.service
systemctl enable py_autorun.service
