sudo apt update
echo "y" | sudo apt install squid

echo "Enter username: "
read username

echo "Enter password: "
read password

printf "$username:$(openssl passwd -crypt '$password')\n" | sudo tee -a /etc/squid/htpasswd

sudo mv /etc/squid/squid.conf /etc/squid/squid.old.conf

sudo echo "
acl localnet src 0.0.0.1-0.255.255.255  # RFC 1122 network (LAN)
acl localnet src 10.0.0.0/8             # RFC 1918 local private network (LAN)
acl localnet src 100.64.0.0/10          # RFC 6598 shared address space (CGN)
acl localnet src 169.254.0.0/16         # RFC 3927 link-local (directly plugged) machines
acl localnet src 172.16.0.0/12          # RFC 1918 local private network (LAN)
acl localnet src 192.168.0.0/16         # RFC 1918 local private network (LAN)
acl localnet src fc00::/7               # RFC 4193 local private network range
acl localnet src fe80::/10              # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/htpasswd
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
include /etc/squid/conf.d/*
http_access allow localhost
http_access allow authenticated
http_access deny all
http_port 3128

coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims
refresh_pattern \/InRelease$ 0 0% 0 refresh-ims
refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern .               0       20%     4320
" > /etc/squid/squid.conf

sudo mv ~/squid.conf /etc/squid/squid.conf

sudo systemctl restart squid
sudo ufw allow 'Squid'

