systemctl stop aptosd
systemctl disable aptosd
rm -rf ~/aptos*
rm -rf ~/.aptos
rm -rf /opt/aptos/
wget -q -O aptos.sh https://api.nodes.guru/aptos.sh && chmod +x aptos.sh && sudo /bin/bash aptos.sh
source ~/.bash_profile
cat ~/.aptos/$APTOS_NODENAME.yaml
