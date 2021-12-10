#!/bin/sh
set -e

echo "Stopping minima service"
systemctl stop minimad
echo "Disabling minima service"
systemctl disable minimad

echo "Removing old minima service"
rm /etc/systemd/system/minimad.service
systemctl daemon-reload
systemctl reset-failed

echo "Removing data directory /root/.minima"
rm -rf /root/.minima

echo "Removing minima jars and scripts"
rm minima.jar*
rm minima_update.sh*
rm minima_service.sh*
