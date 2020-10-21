# ! /bin/sh

basepath=$(cd `dirname $0`; pwd)

while true
do
    procnum=`ps -ef|grep service|grep -v grep|wc -l`
    if [ $procnum -eq 0 ]
    then
        #启动命令
        echo `date +%Y-%m-%d` `date +%H:%M:%S`  "restart service" >>$basepath/shell.log
    fi
done