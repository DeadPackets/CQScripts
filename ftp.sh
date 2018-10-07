#!/bin/bash

# Filename
CONFIG_FILE="/etc/vsfptd.conf"
C_FLAG=""

# Edit existing conf options
echo "Replacing values..."
sed $C_FLAG -i "s/\(anonymous_enable *= *\).*/\1NO/" $CONFIG_FILE
sed $C_FLAG -i "s/\(local_umask *= *\).*/\1022/" $CONFIG_FILE

# Create SSL cert
echo "Creating certificates..."
mkdir -p /etc/ssl/certs
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj "/C=AE/ST=Dubai/L=Dubai/O=BlueTeam/OU=BlueTeam/CN=blueteam.com/emailAddress=noreply@blueteam.com" -keyout /etc/ssl/certs/vsftpd.pem -out /etc/ssl/certs/vsftpd.pem

# Edit conf
echo "Appending conf file..."
echo "rsa_cert_file=/etc/ssl/vsftpd.pem" >> $CONFIG_FILE
echo "rsa_private_key_file=/etc/ssl/vsftpd.pem" >> $CONFIG_FILE
echo "ssl_enable=YES" >> $CONFIG_FILE
echo "allow_anon_ssl=NO" >> $CONFIG_FILE
echo "force_local_data_ssl=YES" >> $CONFIG_FILE
echo "force_local_logins_ssl=YES" >> $CONFIG_FILE
echo "ssl_tlsv1=YES" >> $CONFIG_FILE
echo "ssl_sslv2=NO" >> $CONFIG_FILE
echo "ssl_sslv3=NO" >> $CONFIG_FILE
echo "require_ssl_reuse=NO" >> $CONFIG_FILE
echo "ssl_ciphers=HIGH" >> $CONFIG_FILE

# Restart ftp
echo "Restarting vsftpd..."
service vstpd restart

# Open file for output
#echo "Opening file..."	