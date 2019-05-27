yum install -y epel-release
yum install -y python-pip
pip install --upgrade pip --default-timeout=6000
pip install docker-compose --default-timeout=6000
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose