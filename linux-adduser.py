#coding:utf-8
import os

# add name -s /bin/bash
# echo passwd | passwd --stdin name

#需要添加的用户名
username_list = ['zy','lds','zxy','xww','hly','zsy','wj']
password = '123456'

passwd_file = open('/etc/passwd','r')
file = passwd_file.readlines()
passwd_file.close()

#print file
#得到已存在的用户名
userlist = []
for listdata in file :
	listname = listdata.split(':',1)[0]
	userlist.append(listname)
#print userlist

for username in username_list:
#	print username
	if username in userlist:
		print 'the user %(name)s exists.'%{'name':username}
	else :
		os.system('useradd %(name)s -s /bin/bash'%{'name':username})
		print 'user %s created.'%username
		os.system('echo %(password)s | passwd --stdin %(name)s'%{'name':username,'password':password})
