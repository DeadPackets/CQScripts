#!/bin/bash

sudo apt install lynis rkhunter -y

echo "Updating rkhunter..."
sudo rkhunter --update
sudo rkhunter --propupd

echo "Running rkhunter..."
sudo rkhunter -c --enable all --disable none

echo "Running lynis tests..."
sudo lynis audit system -Q