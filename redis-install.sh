# 环境准备
yum install -y wget gcc

#下载官方安装源
wget http://download.redis.io/releases/redis-5.0.4.tar.gz
tar -xf redis-5.0.4.tar.gz
cd redis-5.0.4/

#编译安装
make
make PREFIX=/usr/local/redis install CFLAGS="-march=x86-64"
cp redis.conf /usr/local/redis/conf/

cat > /etc/profile.d/redis.sh << EOF
export PATH=/usr/local/redis/bin:$PATH
EOF
source /etc/profile.d/redis.sh
#配置文件
# vi redis.conf

#部署1：单节点启动
redis-server /usr/local/redis/conf/redis.conf

#部署2：开启主从模式
echo "slaveof $IP $PORT" >> /usr/local/redis/conf/redis.conf

#部署3：开启集群模式
sed -i 's/\#cluster-enabled/cluster-enabled/g' /usr/local/redis/conf/redis.conf
#多节点生成集群(需要6节点)
redis-cli --cluster create --cluster-replicas 1 $IP1:$PORT1 $IP2:$PORT2 $IP3:$PORT3 $IP4:$PORT4 $IP5:$PORT5 $IP6:$PORT6
