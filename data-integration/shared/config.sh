useradd -m -s /bin/bash hadoop
echo "Defina a senha:"
passwd hadoop

sh -c "echo '127.0.0.1 localhost namenode' >> /etc/hosts"

export HADOOP_HOME=/opt/hadoop
export JAVA_HOME=/usr/local/openjdk-8
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin:$PATH

cat <<EOF >> /etc/profile
# Hadoop e outros frameworks
export HADOOP_HOME=/opt/hadoop
export JAVA_HOME=/usr/local/openjdk-8
export SQOOP_HOME=/opt/sqoop
export HBASE_HOME=/opt/hbase
export HIVE_HOME=/opt/hive

export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$JAVA_HOME/bin:\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$HBASE_HOME/bin:\$HBASE_HOME/sbin:\$HIVE_HOME/bin:\$HIVE_HOME/sbin:\$PATH
EOF
source /etc/profile

chown -R hadoop:hadoop /opt/hadoop
chown -R hadoop:hadoop /opt/sqoop
chown -R hadoop:hadoop /opt/hbase
chown -R hadoop:hadoop /opt/hive

echo "Configurando hadoop-env.sh..."
HADOOP_ENV="$HADOOP_HOME/etc/hadoop/hadoop-env.sh"
if [ ! -f "$HADOOP_ENV" ]; then
    touch "$HADOOP_ENV"
fi
cat <<EOL > "$HADOOP_ENV"
export JAVA_HOME=$JAVA_HOME
export HDFS_NAMENODE_USER=hadoop
export HDFS_DATANODE_USER=hadoop
export HDFS_SECONDARYNAMENODE_USER=hadoop
export YARN_NODEMANAGER_USER=hadoop
export YARN_RESOURCEMANAGER_USER=hadoop
EOL

apt update 
service ssh start

su - hadoop -c "
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
fi
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
"
mv /opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar /tmp/

mkdir -p $HADOOP_HOME/tmp
chown -R hadoop:hadoop $HADOOP_HOME/tmp

su - hadoop -c "ssh localhost exit"