
# inotify install
wget http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz
tar xzf inotify-tools-3.14.tar.gz ;cd inotify-tools-3.14
./configure --prefix=/usr/local/inotify && make && make install

echo 'PATH=$PATH:/usr/inotify/bin/' >> /etc/profile

#inotify monitor
# monitor_dir=''
# inotifywait -mrq --timefmt '%Y%m%d-%H%M%S' --format '%T %w %f' -e modify,delete,create,move,attrib ${monitor_dir}