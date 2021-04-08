# coding: utf-8

from tkinter import *
import tkinter.messagebox
import tkinter.simpledialog
from ftplib import FTP
import traceback
import tarfile
import os
import json

class Ui(object):
    def __init__(self):
        self.ftp = FtpClient()
        self.root = Tk()
        self.menu = Menu(self.root)
        self.menu1 = Menu(self.menu, tearoff=False)
        self.menu2 = Menu(self.menu, tearoff=False)
        self.info_label = Label(self.root, text='点击更新hcm平台版本')
        self.button_update = Button(self.root, text='更新', command=self.update, width=5, height=2)
        self.button_quit = Button(self.root, text='退出', command=self.root.destroy, width=5)

        self.window_init()
        self.menu_init()
        self.dom_init()
        self.root.mainloop()

    def window_init(self, title='hcm更新工具', geometry='300x250'):
        self.root.title(title)
        self.root.geometry(geometry)

    def menu_init(self):
        self.root['menu'] = self.menu
        # self.root.config(menu=self.menu)
        self.menu1.add_command(label='更新', command=self.update)
        self.menu1.add_command(label='配置', command=self.message_ftp_config)
        self.menu1.add_separator()
        self.menu1.add_command(label='退出', command=self.root.destroy)

        self.menu2.add_command(label='说明', command=self.message_intro)
        self.menu2.add_command(label='关于', command=self.message_about)

        self.menu.add_cascade(label='操作', menu=self.menu1)
        self.menu.add_cascade(label='帮助', menu=self.menu2)

    def dom_init(self):
        self.info_label.place(relx=0.5, rely=0.3, anchor=CENTER)
        self.button_update.place(relx=0.5, rely=0.5, anchor=CENTER)
        self.button_quit.place(relx=0.5, rely=0.7, anchor=CENTER)

    def message_ftp_config(self):
        try:
            res = tkinter.messagebox.askquestion("警告", "即将配置ftp服务器，请确认知晓正确配置信息")
            if res == 'yes':
                host = tkinter.simpledialog.askstring("地址", "请输入ftp地址：")
                port = tkinter.simpledialog.askinteger("端口", "请输入端口，默认输入 21：")
                username = tkinter.simpledialog.askstring("用户名", "请输入用户名:")
                password = tkinter.simpledialog.askstring("密码", "请输入密码：")
                target_path = tkinter.simpledialog.askstring('路径', "请输入下载路径，默认请输入 /：")
                handle_file = tkinter.simpledialog.askstring('文件名', "请输入下载文件名，默认请输入 hcm.tar.gz：")
                self.ftp = FtpClient(host=host, port=port, username=username, password=password, target_path=target_path, handle_file=handle_file)
        except Exception as e:
            traceback.print_exc()

    @staticmethod
    def message_intro():
        tkinter.messagebox.showinfo('说明', 'hcm项目前端更新工具，基于ftp远端拉取本地解压更新实现')

    @staticmethod
    def message_about():
        tkinter.messagebox.showinfo('关于', 'author: wujimaster')

    def update(self):
        self.info_label.configure(text='正在更新,请稍等...')
        ftp = FtpClient()
        _result = ftp.retrieve()
        if _result is True:
            self.info_label.configure(text='下载成功，准备解压...')

            _result0 = os.system('dir hcm.tar.gz')
            if _result0 == 0:
                self.info_label.configure(text='正在解压，请稍等...')
                _result1 = ftp.uncompress()
                if _result1 is True:
                    self.info_label.configure(text='解压更新完成，请登录hcm平台查看。')
                else:
                    self.info_label.configure(text='解压更新失败，请检查。')
            else:
                self.info_label.configure(text='下载文件不存在，请检查下载情况。')

        else:
            self.info_label.configure(text='下载失败，请检查服务器配置及网络情况。')


class FtpClient(object):
    def __init__(self, host='127.0.0.1', port=21, username='wuji', password='wuji',target_path='/', handle_file='hcm.tar.gz'):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.target_path = target_path
        self.handle_file = handle_file
        self.get_config()
        self.f = FTP()

        self.connect_init()

    def get_config(self):
        try:
            _result = os.system('dir config.json')
            if _result == 0:
                with open("config.json", "r") as f:
                    data = json.load(f)
                    self.host = data['host']
                    self.port = data['port']
                    self.username = data['username']
                    self.password = data['password']
                    self.target_path = data['target_path']
                    self.handle_file = data['handle_file']
            else:
                pass
        except Exception as e:
            traceback.print_exc()

    def connect_init(self):
        try:
            self.f.set_debuglevel(2)
            self.f.set_pasv(False)
            self.f.connect(self.host, self.port)
            self.f.login(self.username, self.password)
            return True
        except Exception as e:
            traceback.print_exc()
            return False

    def retrieve(self):
        try:
            self.f.cwd(self.target_path)
            bufsize = 1024
            fp = open(self.handle_file, 'wb')
            self.f.retrbinary('RETR {}'.format(self.handle_file), fp.write, bufsize)
            return True
        except Exception as e:
            traceback.print_exc()
            return False

    def uncompress(self):
        try:
            t = tarfile.open(self.handle_file)
            t.extractall(path='./')
            return True
        except Exception:
            traceback.print_exc()
            return False


def main():
    ui = Ui()


if __name__ == '__main__':
    main()
