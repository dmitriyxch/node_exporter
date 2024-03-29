sudo apt update
echo "y" | sudo apt install apache2-utils squid  

#echo "Enter username: "
#read username

#echo "Enter password: "
#read password

echo "Your ip: "
read ip

printf "$ip" | sudo tee -a /etc/squid/allowed_ips.txt

sudo htpasswd -c /etc/squid/passwd adm_dante
 
#printf "$username:$(openssl passwd -crypt '$password')\n" | sudo tee -a /etc/squid/htpasswd

sudo mv /etc/squid/squid.conf /etc/squid/squid.old.conf


echo "
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


#allow basic auth
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 10
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive off
acl authenticated proxy_auth REQUIRED


#allow ips from file
acl allowed_ips src '/etc/squid/allowed_ips.txt'


http_access allow localhost manager
http_access allow allowed_ips
#include /etc/squid/conf.d/*
http_access allow localhost
http_access allow authenticated
http_access deny manager
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access deny all
http_port 3128

#hide proxy headers
via off
forwarded_for delete
request_header_access From deny all
request_header_access Referer deny all
request_header_access User-Agent deny all

follow_x_forwarded_for deny all
request_header_access X-Forwarded-For deny all
header_access X_Forwarded_For deny all

request_header_access From deny all
request_header_access Server deny all
request_header_access WWW-Authenticate deny all
request_header_access Link deny all
request_header_access Cache-Control deny all
request_header_access Proxy-Connection deny all
request_header_access X-Cache deny all
request_header_access X-Cache-Lookup deny all
request_header_access Via deny all
request_header_access X-Forwarded-For deny all
request_header_access Pragma deny all
request_header_access Keep-Alive deny all

coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims
refresh_pattern \/InRelease$ 0 0% 0 refresh-ims
refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern .               0       20%     4320
" > squid.conf

sudo mv squid.conf /etc/squid/squid.conf

sudo systemctl restart squid
sudo ufw allow 'Squid'

echo "Your proxy ip:"
dig +short myip.opendns.com @resolver4.opendns.com
