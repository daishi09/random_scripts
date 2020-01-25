#!/bin/bash
#####################################################################################################
# Script_Name : smtp_receiver.sh
# Description : simulates smtp traffic with custom message
# Date : January 2020
####################################################################################################

# ----- Create a script to run smtp_receiver.py as a service while sending errors to /dev/null to avoid filling logs
cat > /root/smtp_receiver.py << "__EOF__"
import smtpd
import asyncore

class CustomSMTPServer(smtpd.SMTPServer):

    def process_message(self, peer, mailfrom, rcpttos, data):
        print 'Receiving message from:', peer
        print 'Message addressed from:', mailfrom
        print 'Message addressed to  :', rcpttos
        print 'Message length        :', len(data)
        return

server = CustomSMTPServer(('0.0.0.0', 25), None)

asyncore.loop()
__EOF__

# ----- Create a script to run smtp_receiver.py while sending errors to /dev/null to fix log filling issue
cat > /root/py_rcv_autorun.sh <<"__EOF__"
#!/bin/sh
while [ true ]
do
 /usr/bin/python /root/smtp_receiver.py 2>/dev/null
done
__EOF__

# ----- Make autorun script executable
chmod +x /root/py_rcv_autorun.sh

# ----- Create py_rcv_autorun service
cat > /lib/systemd/system/py_rcv_autorun.service <<"__EOF__"
[Unit]
Description=Python SMTP Receiver Autorun Service

After=network.target
StartLimitInterval=0

[Service]
Type=simple
Restart=on-failure
RestartSec=1
User=root
ExecStart=/bin/bash /root/py_rcv_autorun.sh

[Install]
WantedBy=multi-user.target
__EOF__

# ----- Start and enable python receiver service
systemctl start py_rcv_autorun.service
systemctl enable py_rcv_autorun.service
