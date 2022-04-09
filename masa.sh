sudo apt install apt-transport-https net-tools git mc sysstat atop curl tar wget clang pkg-config libssl-dev jq build-essential make ncdu -y
sudo addgroup p2p 
sudo adduser masa --ingroup p2p --disabled-password --disabled-login --shell /usr/sbin/nologin --gecos ""
ver="1.17.5"
cd ~
wget --inet4-only "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
sleep 5
echo "1"
rm "go$ver.linux-amd64.tar.gz"
echo "2"
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.profile
echo "3"
source ~/.profile
echo "4"
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> /home/masa/.profile
echo "5"
sleep 5
echo "6"
sudo su masa -s /bin/bash
echo "7"
sleep 5
cd ~
echo "8"
source ~/.profile
echo "9"
git clone https://github.com/masa-finance/masa-node-v1.0
echo "10"
cd masa-node-v1.0/src
make all
exit
sudo -i 
cp /home/masa/masa-node-v1.0/src/build/bin/* /usr/local/bin
exit
sudo su masa -s /bin/bash
cd ~
source ~/.profile
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
exit
sudo -i
read NODE_NAME
tee /etc/systemd/system/masad.service > /dev/null <<EOF
[Unit]
Description=MASA
After=network.target
[Service]
Type=simple
User=masa
ExecStart=/usr/local/bin/geth \\
--identity ${NODE_NAME} \\
--datadir /home/masa/masa-node-v1.0/data \\
--bootnodes "enode://7612454dd41a6d13138b565a9e14a35bef4804204d92e751cfe2625648666b703525d821f34ffc198fac0d669a12d5f47e7cf15de4ebe65f39822a2523a576c4@81.29.137.40:30300" \\
--emitcheckpoints \\
--istanbul.blockperiod 10 \\
--mine \\
--miner.threads 1 \\
--syncmode full \\
--verbosity 5 \\
--networkid 190260 \\
--rpc \\
--rpccorsdomain "*" \\
--rpcvhosts "*" \\
--rpcaddr 127.0.0.1 \\
--rpcport 8545 \\
--rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \\
--port 30300
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
Environment="PRIVATE_CONFIG=ignore"
[Install]
WantedBy=multi-user.target
EOF
exit
sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad
sudo systemctl status masad
journalctl -u masad -f
