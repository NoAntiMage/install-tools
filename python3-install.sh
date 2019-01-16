yum install make gcc gcc-c++ 
mkdir -p /server/tools/
cd /server/tools/
wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tgz
tar -xf Python-3.6.2.tgz
cd Python-3.6.2
./configure
make
make install
ln -s /usr/local/bin/python3 /usr/bin/python3
pip3 install --upgrade pip
pip3 -V
python3 -V