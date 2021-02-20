yum install -y make gcc gcc-c++ 
yum install -y zlib zlib-devel
yum -y install bzip2 bzip2-devel ncurses openssl openssl-devel openssl-static xz lzma xz-devel sqlite sqlite-devel gdbm gdbm-devel tk tk-devel libffi-devel
mkdir -p /server/tools/
cd /server/tools/
wget https://www.python.org/ftp/python/3.8.4/Python-3.8.4.tgz
tar -xf Python-3.8.4.tgz
cd Python-3.8.4
./configure
make
make install
ln -s /usr/local/bin/python3 /usr/bin/python3
pip3 install --upgrade pip
pip3 -V
python3 -V
