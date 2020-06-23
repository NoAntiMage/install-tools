tar -zxvf jdk-8u231-linux-x64.tar.gz
mv jdk1.8.0_231 /usr/local/java

#vi /etc/profile 
echo 'JAVA_HOME=/usr/local/java/
export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=$PATH:${JAVA_HOME}/bin' >> /etc/profile


source /etc/profile

java -version