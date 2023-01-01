sudo apt update
echo y | sudo apt install dante-server
sudo rm /etc/danted.conf

sudo touch /var/log/dante.log

echo "
errorlog: syslog
#logoutput: syslog stdout /var/log/dante.log
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=8111

# The proxying network interface or address.
external: eth0

# socks-rules determine what is proxied through the external interface.
socksmethod: username

# client-rules determine who can connect to the internal interface.
clientmethod: none

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}
" > danted.conf

sudo mv danted.conf /etc/danted.conf


sudo ufw allow 8111

sudo useradd -r -s /bin/false adm_dante
sudo passwd adm_dante

sudo systemctl restart danted.service

systemctl status danted.service
