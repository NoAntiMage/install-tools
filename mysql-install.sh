yum install -y wget
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum list installed | grep mysql
yum -y install mysql-server mysql mysql-devel