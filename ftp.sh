#!/bin/bash

# Filename
CONFIG_FILE="/etc/vsfptd.conf"
C_FLAG="-c"

# Edit existing conf options
sed $C_FLAG -i "s/\(anonymous_enable *= *\).*/\1NO/" $CONFIG_FILE
sed $C_FLAG -i "s/\(local_umask *= *\).*/\1022/" $CONFIG_FILE

# Create SSL cert
mkdir -p /etc/ssl/certs
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj "/C=AE/ST=Dubai/L=Dubai/O=BlueTeam/OU=BlueTeam/CN=blueteam.com/emailAddress=noreply@blueteam.com" -keyout /etc/ssl/certs/vsftpd.pem -out /etc/ssl/certs/vsftpd.pem

# Edit conf
rsa_cert_file=/etc/ssl/vsftpd.pem
rsa_private_key_file=/etc/ssl/vsftpd.pem
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
require_ssl_reuse=NO
ssl_ciphers=HIGH

# Restart ftp
service vstpd restart

# Open file for output
cat $CONFIG_FILE | more
