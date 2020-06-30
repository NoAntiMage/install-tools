IP=`ip a| grep inet | sed -n '3p'|cut -d '/' -f 1 | awk '{print $NF}'`

systemctl disable firewalld
systemctl stop firewalld
yum install -y nfs-utils
setenforce 0
mkdir -p /nfs/data/
chmod -R 777 /nfs/data
echo '/nfs/data *(rw,no_root_squash,sync)' >> /etc/exports
exportfs -r
systemctl restart rpcbind && systemctl enable rpcbind
systemctl restart nfs && systemctl enable nfs
showmount -e $IP