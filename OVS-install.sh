yum -y install openssl-devel wget kernel-devel policycoreutils-python.x86_64 0:2.2.5-11.el7
yum groupinstall "Development Tools"
# adduser ovswitch
# su - ovswitch
wget http://openvswitch.org/releases/openvswitch-2.3.0.tar.gz
tar xfz openvswitch-2.3.0.tar.gz
mkdir -p ~/rpmbuild/SOURCES
sed 's/openvswitch-kmod, //g' openvswitch-2.3.0/rhel/openvswitch.spec > openvswitch-2.3.0/rhel/openvswitch_no_kmod.spec
cp openvswitch-2.3.0.tar.gz rpmbuild/SOURCES
rpmbuild -bb --without check ~/openvswitch-2.3.0/rhel/openvswitch_no_kmod.spec
yum localinstall /root/rpmbuild/RPMS/x86_64/openvswitch-2.3.0-1.x86_64.rpm
mkdir /etc/openvswitch
semanage fcontext -a -t openvswitch_rw_t "/etc/openvswitch(/.*)?"
restorecon -Rv /etc/openvswitch
systemctl start openvswitch.service
systemctl -l status openvswitch.service