#!/bin/bash

# Start with apache2, install stuff
sudo apt install libapache2-mod-security2 git -y

# Hide Apache2 version
echo "ServerSignature Off" >> /etc/apache2/apache2.conf
echo "ServerTokens Prod" >> /etc/apache2/apache2.conf

# Remove ETags
echo "FileETag None" >> /etc/apache2/apache2.conf

# Disable Directory Browsing
a2dismod -f autoindex

# Secure root directory
echo "<Directory />" >> /etc/apache2/conf-available/security.conf
echo "Options -Indexes" >> /etc/apache2/conf-available/security.conf
echo "AllowOverride None" >> /etc/apache2/conf-available/security.conf
echo "Order Deny,Allow" >> /etc/apache2/conf-available/security.conf
echo "Deny from all" >> /etc/apache2/conf-available/security.conf
echo "</Directory>" >> /etc/apache2/conf-available/security.conf

# Secure html directory
echo "<Directory /var/www/html>" >> /etc/apache2/conf-available/security.conf
echo "Options -Indexes -Includes" >> /etc/apache2/conf-available/security.conf
echo "AllowOverride None" >> /etc/apache2/conf-available/security.conf
echo "Order Allow,Deny" >> /etc/apache2/conf-available/security.conf
echo "Allow from All" >> /etc/apache2/conf-available/security.conf
echo "</Directory>" >> /etc/apache2/conf-available/security.conf

# Enable headers module
a2enmod headers

# Enable HttpOnly and Secure flags
echo "Header edit Set-Cookie ^(.*)\$ \$1;HttpOnly;Secure" >> /etc/apache2/conf-available/security.conf

# Clickjacking Attack Protection
echo "Header always append X-Frame-Options SAMEORIGIN" >> /etc/apache2/conf-available/security.conf

# XSS Protection
echo "Header set X-XSS-Protection \"1; mode=block\"" >> /etc/apache2/conf-available/security.conf

# MIME sniffing Protection
echo "Header set X-Content-Type-Options: \"nosniff\"" >> /etc/apache2/conf-available/security.conf

# Prevent Cross-site scripting and injections
echo "Header set Content-Security-Policy \"default-src 'self';\"" >> /etc/apache2/conf-available/security.conf

# Prevent DoS attacks - Limit timeout
sed -i "s/Timeout 300/Timeout 60/" /etc/apache2/apache2.conf

# Mod security
mv ./modsecurity.conf /etc/modsecurity/modsecurity.conf
sudo service apache2 restart
rm -rf /usr/share/modsecurity-crs
git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/share/modsecurity-crs
cd /usr/share/modsecurity-crs
mv crs-setup.conf.example crs-setup.conf
mv ./security2 /etc/apache2/mods-enabled/security2.conf
sudo service apache2 restart
sudo service httpd restart

# SSH

# Set /etc/ssh/sshd_config ownership and access permissions
chown root:root /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config

# Change Port
sed -i "s/#Port 22/Port 62111/g" /etc/ssh/sshd_config

# Protocol 2
echo "Protocol 2" >> /etc/ssh/sshd_config

# Set SSH LogLevel to INFO
sed -i "/LogLevel.*/s/^#//g" /etc/ssh/sshd_config

# Set SSH MaxAuthTries to 3
sed -i "s/#MaxAuthTries 6/MaxAuthTries 3/g" /etc/ssh/sshd_config

# Enable SSH IgnoreRhosts
sed -i "/IgnoreRhosts.*/s/^#//g" /etc/ssh/sshd_config

# Disable SSH HostbasedAuthentication
sed -i "/HostbasedAuthentication.*no/s/^#//g" /etc/ssh/sshd_config

# Disable SSH root login
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config

# Deny Empty Passwords
sed -i "/PermitEmptyPasswords.*no/s/^#//g" /etc/ssh/sshd_config

# Deny Users to set environment options through the SSH daemon
sed -i "/PermitUserEnvironment.*no/s/^#//g" /etc/ssh/sshd_config

service ssh restart
