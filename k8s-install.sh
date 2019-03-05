systemctl disable firewalld
systemctl stop firewalld
yum update -y
yum install -y wget net-tools
yum install -y etcd kubernetes

setenforce 0

sed -i "s/OPTIONS='--selinux-enabled --log-driver=journald --signature-verification=false'/OPTIONS='--selinux-enabled=false --insecure-registry gcr.io'/g" /etc/sysconfig/docker
sed -i "s/ServiceAccount,//g" /etc/kubernetes/apiserver

for SERVICES in etcd docker kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy
do
        systemctl restart $SERVICES && systemctl enable $SERVICES
done

# yum install -y *rhsm*

wget http://mirror.centos.org/centos/7/os/x86_64/Packages/python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm
rpm2cpio python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm | cpio -iv --to-stdout ./etc/rhsm/ca/redhat-uep.pem | tee /etc/rhsm/ca/redhat-uep.pem
docker pull registry.access.redhat.com/rhel7/pod-infrastructure:latest

kubectl version