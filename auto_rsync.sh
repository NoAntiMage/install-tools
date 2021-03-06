#!/bin/sh
SRC='/app/'
DIST='/app/'
user='root'
IP='192.168.239.158'

inotifywait -mrq --format '%w%f' -e modify,create,attrib ${SRC} | while
read line
do
  if [ -f $line ];then
    echo $line
    rsync -azurtopg --bwlimit=200 $line $user@$IP:$line
  fi
  if [ -d $line ];then
    echo $line
    rsync -azurtopg --bwlimit=200 $line/ $user@$IP:$line/
  fi

done

