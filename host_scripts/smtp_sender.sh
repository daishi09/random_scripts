#!/bin/bash
#####################################################################################################
# Script_Name : smtp_sender.sh
# Description : simulates smtp traffic with custom message
# Date : January 2020
####################################################################################################

# ----- Create a script to run smtp_sender.py as a service while sending errors to /dev/null to avoid filling logs
cat > /root/smtp_sender.py <<"__EOF__"
import time
import smtplib
import email.utils
from email.mime.text import MIMEText

while True:

  time.sleep(30)
  # ---- email message
  msg = MIMEText('Leroy, the username and password for the server at 172.16.101.2 is horde:forthehorde. You can begin uploading your findings there!')
  msg['To'] = email.utils.formataddr(('Recipient', 'leeroyjenkins@gmail.com'))
  msg['From'] = email.utils.formataddr(('Author', 'igotchicken@ymail.com'))
  msg['Subject'] = 'creds4fun'

  server = smtplib.SMTP('0.0.0.0', 25)
  server.set_debuglevel(True) # show communication with the server

  try:
    server.sendmail('igotchicken@ymail.com', ['leeroyjenkins@gmail.com'], msg.as_string())
  finally:
    server.quit()
__EOF__

# ----- Create a script to run smtp_sender.py while sending errors to /dev/null to fix log filling issue
cat > /root/py_snd_autorun.sh <<"__EOF__"
#!/bin/sh
while [ true ]
do
  /usr/bin/python /root/smtp_sender.py 2>/dev/null
done
__EOF__

# ----- Make autorun script executable
chmod +x /root/py_snd_autorun.sh

# ----- Create py_snd_autorun service
cat > /lib/systemd/system/py_snd_autorun.service <<"__EOF__"
[Unit]
Description=Python SMTP Sender Autorun Service

After=network.target
StartLimitInterval=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/bin/bash /root/py_snd_autorun.sh

[Install]
WantedBy=multi-user.target
__EOF__

# ----- Start and enable python sender service
systemctl start py_snd_autorun.service
systemctl enable py_snd_autorun.service
