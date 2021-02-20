wget https://archive.apache.org/dist/kafka/2.1.0/kafka_2.12-2.1.0.tgz

tar -zxvf kafka_2.12-2.1.0.tgz
mv kafka_2.12-2.1.0 kafka
mv kafka /usr/local/

cat > /etc/systemd/system/zookeeper.service << EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
ExecStart=/usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
ExecStop=/usr/local/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target

EOF

cat > /etc/systemd/system/kafka.service << EOF
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
ExecStart=/bin/sh -c '/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties > /usr/local/kafka/kafka.log 2>&1'
ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl start zookeeper
systemctl start kafka

# ./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic topic-name
# ./kafka-topics.sh --list --zookeeper localhost:2181
# ./kafka-console-producer.sh --broker-list localhost:9092 --topic topic-name
# ./kafka-console-consumer.sh --topic topic-name --bootstrap-server localhost:9092 --from-beginning