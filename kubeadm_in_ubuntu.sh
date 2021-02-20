# 环境准备
# 设置系统时区
timedatectl set-timezone Asia/Shanghai
# 将当前的 UTC 时间写入硬件时钟
timedatectl set-local-rtc 0
# 重启依赖于系统时间的服务
systemctl restart rsyslog
systemctl restart cron
# 时间同步
apt -y install chrony
systemctl enable chrony
chronyc -a makestep

# 1.安装Docker
# step 1: 安装必要的一些系统工具
apt update
apt -y install apt-transport-https ca-certificates software-properties-common
# step 2: 安装GPG证书
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add
# Step 3: 写入软件源信息
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" 
# Step 4: 更新并安装 Docker-CE
apt update
# Step 5: 查找Docker-CE的版本,安装指定版本的Docker-CE
apt-cache madison docker-ce
apt -y install docker-ce=5:19.03.12~3-0~ubuntu-bionic
systemctl enable docker && systemctl start docker
# Step 5: Docker设置
cat > /etc/docker/daemon.json << EOF
{
	    "registry-mirrors": ["https://g2djyyu3.mirror.aliyuncs.com"],
	        "exec-opts": [ "native.cgroupdriver=systemd" ]
}
EOF

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
# 2.禁用swap文件
# 然后需要禁用swap文件，这是Kubernetes的强制步骤。实现它很简单，编辑/etc/fstab文 件，注释掉引用swap的行，保存并重启后输入swapoff -a即可。
## 关闭swap
echo "vm.swappiness=0" >> /etc/sysctl.d/k8s.conf
sysctl -p /etc/sysctl.d/k8s.conf

# 开始正式安装kubernetes
# (1/4) 添加kubernetes安装源
curl -s http://packages.faasx.com/google/apt/doc/apt-key.gpg | sudo apt-key add
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.ustc.edu.cn/kubernetes/apt/ kubernetes-xenial main
EOF
# 安装 kubeadm, kubelet and kubectl
apt update
apt install -y kubelet kubeadm kubectl

#安装指定版本的方法
apt-cache madison kubeadm kubelet kubectl
apt -y install kubeadm=1.18.4-00
apt -y install kubelet=1.18.4-00
apt -y install kubectl=1.18.4-00

# apt-key下载地址使用了国内镜像，官方地址为： https://packages.cloud.google.com/apt/doc/apt-key.gpg
# apt安装包地址使用了中科大的镜像，官方地址为：http://apt.kubernetes.io/

# (2/4)初始化master节点
kubeadm init --config kubeadm.yaml

# cat kubeadm.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
imageRepository: mirrorgcrio
kubernetesVersion: v1.18.4
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
scheduler: {}
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
ipvs:
mode: ipvs

# 配置kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# (3/4) 安装Pod网络插件
# 要让Kubernetes Cluster能够工作，必须安装Pod网络，否则Pod之间无法通信
# 文件查看地址 https://github.com/coreos/flannel/blob/master/Documentation/kube-flannel.yml
kubectl apply -f  kube-flannel.yml

# (4/4) 加入其他节点
kubeadm join xxx
# 对于较长时间之后加入cluster的节点token可能已经过期了,默认24小时。此时可以创建新的token之后再加入
kubeadm token create
# 或者使用如下命令查看加入的完整命令：
kubeadm token create --print-join-command

# 为了使用更便捷，启用kubectl命令的自动补全功能：
echo "source <(kubectl completion bash)" >> ~/.bashrc