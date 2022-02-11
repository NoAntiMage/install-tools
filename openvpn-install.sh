yum install -y epel-release
yum install -y openvpn easy-rsa openssl openssl-devel

mkdir -p /etc/openvpn/easy-rsa
cp /usr/share/doc/easy-rsa-3.0.8/vars.example /etc/openvpn/easy-rsa/vars
cd /etc/openvpn/easy-rsa/
#config vars for easy-rsa
cp -a /usr/share/easy-rsa/3.0.8/* .
#generate keys for server-end
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
./easyrsa sign server server
./easyrsa gen-dh

mkdir keys
openvpn --genkey --secret keys/ta.key

cp -a /usr/share/doc/openvpn-2.4.11/sample/sample-config-files/server.conf /etc/openvpn/server.conf
#config server.conf for openvpn
openvpn --daemon --config /etc/openvpn/server.conf

#/etc/sysconfig/iptables
#openvpn-server-net 10.8.0.0/24
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A INPUT -s 10.8.0.0/24 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -d 10.8.0.0/24 -j ACCEPT
iptables -A OUTPUT -o tun+ -j ACCEPT