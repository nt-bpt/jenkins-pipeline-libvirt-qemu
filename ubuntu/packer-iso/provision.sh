#!/bin/bash

echo 'Provisioning...'
apt-get update
apt-get upgrade -y
apt-get install -y ufw
ufw allow 22
apt-get install -y net-tools
apt-get install -y cmake
apt-get install -y build-essential
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y python3-venv
apt-get install -y python3-dev
apt-get install -y python3-setuptools
apt-get install -y python3-wheel
apt-get install -y vim
python3 -m venv /opt/sky360/.venv
source /opt/sky360/.venv/bin/activate
python3 -m pip install -r /opt/sky360/requirements.txt
deactivate
chown -R skytester /opt/sky360
chown -R skytester /opt/sky360/.venv
chgrp -R skytester /opt/sky360
chgrp -R skytester /opt/sky360/.venv