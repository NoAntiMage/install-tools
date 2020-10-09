# Django SQLite 3.8.3 or later is required (found 3.7.17)

wget https://www.sqlite.org/2019/sqlite-autoconf-3300100.tar.gz
cd sqlite-autoconf-3300100/
./configure
make & make install
mv /usr/bin/sqlite3  /usr/bin/sqlite3.bak
ln -s /usr/local/bin/sqlite3 /usr/bin/sqlite3
sqlite3 --version
export LD_LIBRARY_PATH="/usr/local/lib"

# python check
#>import sqlite3
#>sqlite3.sqlite_version()
