#!/bin/sh
# k8s version 1.18.8 following aliyun.repo

IP=`ip a| grep global | head -1 | cut -d / -f 1 | awk '{print $2}'`
VERSION='1.18.8'

# centos 系统初始化
hostnamectl set-hostname master
systemctl stop firewalld && systemctl disable firewalld
setenforce 0 && sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
swapoff  -a &&  sed -ri 's/.*swap.*/#&/' /etc/fstab

# 更换阿里云的源
cat >> /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge‐nf‐call‐ip6tables = 1
net.bridge.bridge‐nf‐call‐iptables = 1
EOF

cat >>/etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y wget
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum clean all
yum repolist -y

yum ‐y remove docker docker‐common docker‐selinux docker‐engine
yum install docker-ce-19.03.12 -y
systemctl start docker && systemctl enable docker

yum install kubelet-${VERSION} kubeadm-${VERSION} kubectl-${VERSION} -y
systemctl start kubelet && systemctl enable kubelet

images=$(kubeadm config images list --kubernetes-version=${VERSION}|awk -F '/' '{print $2}' )

REPO='registry.cn-hangzhou.aliyuncs.com/google_containers'
for imageName in ${images[@]}; do
	docker pull $REPO/${imageName}
	docker tag $REPO/${imageName} k8s.gcr.io/${imageName}
	docker rmi $REPO/${imageName}
done


kubeadm init --kubernetes-version=$VERSION \
--apiserver-advertise-address=$IP \
--service-cidr=10.1.0.0/16 \
--pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl taint node master node-role.kubernetes.io/master-

# next step install flannel, ingress