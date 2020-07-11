#!/bin/sh

WORK_DIR='/usr/local/zookeeper'
DATA_DIR='/tmp/zookeeper'

wget http://mirror.bit.edu.cn/apache/zookeeper/stable/apache-zookeeper-3.5.5.tar.gz
tar xf apache-zookeeper-3.5.5.tar.gz
# cd apache-zookeeper-3.5.5/
mv apache-zookeeper-3.5.5 $WORK_DIR


# 单节点启动
# ${WORK_DIR}/bin/zkServer.sh start

# 单机3节点集群部署
cd $WORK_DIR/conf
for i in `seq 1 3` 
do 
mkdir -p ${DATA_DIR}/zoo$i
cp zoo.cfg zoo$i.cfg
echo "dataDir=${DATA_DIR}/zoo$i
server.1=localhost:2666:3666
server.2=localhost:2667:3667
server.3=localhost:2668:3668" >> zoo$i.cfg
sed -i "s/clientPort=2181/clientPort=218$i/g" zoo$i.cfg
echo $i > ${DATA_DIR}/zoo$i/myid
done

for i in {1..3}
do
	${WORK_DIR}/bin/zkServer.sh start ${WORK_DIR}/conf/zoo$i.cfg
done

chmod +x ${WORK_DIR}/bin/zkCli.sh

${WORK_DIR}/bin/zkCli.sh -server localhost:2181,localhost:2182,localhost:2183
