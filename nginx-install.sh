yum -y install gcc-c++
yum install -y pcre
yum install -y pcre-devel
yum install -y zlib
yum install -y zlib-devel
yum install -y openssl
yum install -y openssl-devel

#rpm install 
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install -y nginx
systemctl start nginx
systemctl enable nginx
systemctl status nginx

#configure install
WORKDIR='/usr/local/nginx1.18'
wget https://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxvf nginx-1.18.0.tar.gz
cd nginx-1.18.0
./configure --prefix=${WORKDIR} 
make && make install
echo 'PATH='${WORKDIR}'sbin/:$PATH' > /etc/profile
source /etc/profile


