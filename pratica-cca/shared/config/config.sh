#!/bin/bash
# Atualize a linha do PATH para:

# Cria usuário hadoop
useradd -m -s /bin/bash hadoop
echo "hadoop:hadoop" | chpasswd
service mysql start
mv /opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar /opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar.bak
# Configura hosts
echo "127.0.0.1 localhost namenode" >> /etc/hosts

cp /shared/scripts/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
cp /shared/scripts/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
cp /shared/scripts/hive-site.xml $HIVE_HOME/conf/hive-site.xml
cp /shared/scripts/sqoop-site.xml $SQOOP_HOME/conf/sqoop-site.xml

# Variáveis de ambiente
cat <<EOF >> /etc/profile
export HADOOP_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive
export SQOOP_HOME=/opt/sqoop
export SPARK_HOME=/opt/spark
export FLUME_HOME=/opt/flume
export JAVA_HOME=/usr/local/openjdk-8/
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HIVE_HOME/bin:\$SQOOP_HOME/bin:\$JAVA_HOME/bin:\$SPARK_HOME/bin:\$FLUME_HOME/bin
export HIVE_HOME=/opt/hive
export CLASSPATH=$HIVE_HOME/lib/*:$CLASSPATH
export CLASSPATH=$HIVE_HOME/lib/hive-beeline-4.0.1.jar:$CLASSPATH
EOF
source /etc/profile

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
export PATH=$PATH:$HIVE_HOME/bin
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:/tmp/sqoop-classes
export CLASSPATH=$HIVE_HOME/lib/*:$CLASSPATH
export CLASSPATH=$HIVE_HOME/lib/hive-beeline-4.0.1.jar:$CLASSPATH
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HIVE_HOME/lib/*
EOL

echo "JAVA_HOME is set to: $JAVA_HOME"

service ssh start
su - hadoop -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"
su - hadoop -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
su - hadoop -c "chmod 600 ~/.ssh/authorized_keys"

su - hadoop -c "ssh-keyscan -H localhost >> ~/.ssh/known_hosts"
su - hadoop -c "ssh-keyscan -H namenode >> ~/.ssh/known_hosts"
su - hadoop -c "ssh-keyscan -H datanode >> ~/.ssh/known_hosts"
cp /shared/other/mysql-connector-java-8.0.28.jar /opt/hive/lib/
su - hadoop -c "export CLASSPATH=$HIVE_HOME/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*:$CLASSPATH"

mysql -u root -p << EOF

ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;

EOF

chown -R hadoop:hadoop /home/hadoop/.ssh
chmod 700 /home/hadoop/.ssh
chmod 600 /home/hadoop/.ssh/id_rsa
chmod 644 /home/hadoop/.ssh/id_rsa.pub
chmod 644 /home/hadoop/.ssh/authorized_keys

chown -R hadoop:hadoop /opt/hadoop
chown -R hadoop:hadoop /opt/sqoop
chown -R hadoop:hadoop /opt/hive
chown -R hadoop:hadoop /opt/spark
chown -R hadoop:hadoop /opt/flume

chown -R hadoop:hadoop /home/hadoop/.ssh
chmod 700 /home/hadoop/.ssh
chmod 600 /home/hadoop/.ssh/id_rsa
chmod 644 /home/hadoop/.ssh/id_rsa.pub
chmod 644 /home/hadoop/.ssh/authorized_keys

# Configuração do Hadoop
su - hadoop -c "hdfs namenode -format -force"  # Força a formatação
su - hadoop -c "$HADOOP_HOME/sbin/stop-dfs.sh"
su - hadoop -c "$HADOOP_HOME/sbin/stop-yarn.sh"
su - hadoop -c "$HADOOP_HOME/sbin/start-dfs.sh"
su - hadoop -c "$HADOOP_HOME/sbin/start-yarn.sh"
sleep 5
# Cria diretórios HDFS essenciais
su - hadoop -c "hdfs dfs -mkdir -p /tmp /user/hive/warehouse"
su - hadoop -c "hdfs dfs -chmod -R 1777 /tmp"
su - hadoop -c "hdfs dfs -chmod -R 775 /user/hive/warehouse"


export CLASSPATH=$HIVE_HOME/lib/*:$CLASSPATH
export CLASSPATH=$HIVE_HOME/lib/hive-beeline-4.0.1.jar:$CLASSPATH

su - hadoop -c "export HIVE_HOME=/opt/hive"
su - hadoop -c "export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HIVE_HOME/lib/*"

touch /var/log/hive-metastore.log /var/log/flume.log
chown hadoop:hadoop /var/log/hive-metastore.log /var/log/flume.log

su - hadoop -c "schematool -initSchema -dbType derby --verbose"
su - hadoop -c "hive --service metastore > /var/log/hive-metastore.log 2>&1 &"

# Inicialização do Spark History Server
su - hadoop -c "$SPARK_HOME/sbin/start-history-server.sh"

# Inicialização do Flume Agent
su - hadoop -c "flume-ng agent -n agent -f /opt/flume/conf/flume.conf > /var/log/flume.log 2>&1 &"

# Inicia serviços básicos
service ssh start
service mysql start
mysqld_safe &

# Mantém o container ativo
tail -f /dev/null &