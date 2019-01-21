yum -y install gcc-c++
yum install -y pcre
yum install -y pcre-devel
yum install -y zlib
yum install -y zlib-devel
yum install -y openssl
yum install -y openssl-devel
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install -y nginx
systemctl start nginx
systemctl enable nginx
systemctl status nginx

