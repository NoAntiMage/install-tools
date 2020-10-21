#!/bin/sh
SRC='/app/'
DIST='/app/'
user='root'
IP='192.168.239.158'

inotifywait -mrq --format '%w%f' -e modify,create ${SRC} | while
read line
do
  if [ -f $line ];then
    echo $line
    rsync -azurtopg $line $user@$IP:$line
  fi
done
