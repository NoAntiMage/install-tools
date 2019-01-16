#coding:UTF-8
#!/usr/bin/python

import os

#删除老版本docker
os.system('sudo yum remove docker \
		                  docker-client \
		                  docker-client-latest \
		                  docker-common \
		                  docker-latest \
		                  docker-latest-logrotate \
		                  docker-logrotate \
		                  docker-selinux \
		                  docker-engine-selinux \
		                  docker-engine')

#安装yum的准备环境
os.system('sudo yum install -y yum-utils \
							  device-mapper-persistent-data \
							  lvm2')

os.system('sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo')

#安装docker
os.system('sudo yum install -y docker-ce')
#GPG key：060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35

os.system('docker -v')
