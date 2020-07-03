yum install -y wget \
&& wget -O /usr/lib/libiperf.so.0 https://iperf.fr/download/ubuntu/libiperf.so.0_3.1.3 \
&& wget -O /usr/bin/iperf3 https://iperf.fr/download/ubuntu/iperf3_3.1.3 \
&& chmod +x /usr/bin/iperf3 \
&& ldconfig
#服务端启动监听： iperf3 -s -i 10
#客户端发送请求：iperf3 -i 10 -w 1M -t 60 -c [server hostname or ip address]
#-w 参数设定window size 大小，此值可为 配置项2倍