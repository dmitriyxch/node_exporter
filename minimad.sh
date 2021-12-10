#!/bin/sh
set -e

echo "Stopping minima service"
systemctl stop minima
systemctl stop minimad
echo "Disabling minima service"
systemctl disable minima
systemctl disable minimad

echo "Removing old minima service"
rm /etc/systemd/system/minimad.service
rm /etc/systemd/system/minima.service
systemctl daemon-reload
systemctl reset-failed

echo "Removing data directory /root/.minima"
rm -rf /root/.minima

echo "Removing minima jars and scripts"
rm minima.jar*
rm minima_update.sh*
rm minima_service.sh*
