# 环境准备
yum install -y wget gcc

#下载官方安装源
wget http://download.redis.io/releases/redis-5.0.4.tar.gz
tar -xf redis-5.0.4.tar.gz
cd redis-5.0.4/

#编译安装
make
make PREFIX=/usr/local/redis install CFLAGS="-march=x86-64"
mkdir -p /usr/local/redis/conf/
cp redis.conf /usr/local/redis/conf/

echo 'export PATH=/usr/local/redis/bin:$PATH' >> /etc/profile
source /etc/profile
#配置文件
# vi redis.conf
sed -i 's/daemonize no/daemonize yes/g' /usr/local/redis/conf/redis.conf
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /usr/local/redis/conf/redis.conf


#部署1：单节点启动
redis-server /usr/local/redis/conf/redis.conf

#部署2：开启主从模式
echo "slaveof $IP $PORT" >> /usr/local/redis/conf/redis.conf

#部署3：开启集群模式
sed -i 's/\# cluster-enabled/cluster-enabled/g' /usr/local/redis/conf/redis.conf
sed -i 's/\# cluster-config-file/cluster-config-file/g' /usr/local/redis/conf/redis.conf
#多节点生成集群(需要6节点)
redis-cli --cluster create --cluster-replicas 1 $IP1:$PORT1 $IP2:$PORT2 $IP3:$PORT3 $IP4:$PORT4 $IP5:$PORT5 $IP6:$PORT6

# https://redis.io/topics/cluster-tutorial/
