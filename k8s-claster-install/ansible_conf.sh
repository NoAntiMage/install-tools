git clone --depth=1 https://github.com/gjmzj/kubeasz.git /etc/ansible
tar -xvf k8s.1-13-5.tar.gz -C /etc/ansible
cd /etc/ansible && cp example/hosts.m-masters.example hosts
