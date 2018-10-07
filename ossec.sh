#!/bin/bash

# Download OSSEC
echo "Downloading OSSEC..."
mkdir ossec && cd ossec
wget https://github.com/ossec/ossec-hids/archive/3.0.0.tar.gz
tar xzf 3.0.0.tar.gz

echo "Installing..."
sudo ./ossec-hids-3.0.0
sudo ./install.sh



echo "Installed! Now to configure..."
cd ..
sudo mv ./ossec.conf /var/ossec/etc/ossec.conf

echo "Done! Now starting ossec..."
sudo /var/ossec/bin/ossec-control start

echo "Installing the OSSEC web ui..."
wget https://github.com/ossec/ossec-wui/archive/master.zip
unzip master.zip
sudo mv ossec-wui-master /var/www/html/ossec
sudo cd /var/www/html/ossec && sudo ./setup.sh
echo "Done! Restarting apache..."
sudo service apache2 restart
