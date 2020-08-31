#/bin/python
#coding: utf8

import os
import sys
import argparse

# ReturnType str for ansible_host_group
def get_parser():
    parser = argparse.ArgumentParser(description="ansible command script.")
    parser.add_argument('-g', type=str,help='choose host group.', default='all')
    args = parser.parse_args()
    return args.g


class Host(object):
    def __init__(self, name, size, used, avail, percent):
        self.name = name
        self.size = size
        self.used = used
        self.avail = avail
	self.percent = percent

    def __str__(self):
	return self.name +':' + self.size +':' +  self.used + ':' + self.avail +':'+ sel


def ansible_check():
    signal = os.system("which ansible > /dev/null 2>&1")
    if signal != 0:
        print("command ansible not found.")
        sys.exit(1)


def ansible_df(host_group='all'):
    result = os.popen("ansible {} -m shell -a 'df /| tail -1'".format(host_group))
    i = 0
    while True:

	line = result.readline().strip('\n')
	if not line:
	    break
	i += 1
	if i % 2 != 0:
	    name = line.split('|')[0].strip()
	    status = line.split('|')[1].strip()
	    if status != 'CHANGED':
		print('{} status is err'.format(name))
	else:
	    free = line.split()
	    # print(free)
	    size = free[1]
	    used = free[2]
	    avail = free[3]
	    percent = free[4].strip('%')
	    host = Host(name=name, size=size, used=used, avail=avail, percent=percent)
	    yield(host)


if __name__ == '__main__':
    ansible_check()
    host_group = get_parser()
    hosts = ansible_df(host_group=host_group)
    for host in hosts:
	print(host)

