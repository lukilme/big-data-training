# Configura variáveis de ambiente para o Hive
su - hadoop -c "export HIVE_HOME=/opt/hive"
su - hadoop -c "export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HIVE_HOME/lib/*"
cp /shared/scripts/hive-site.xml $HIVE_HOME/conf/hive-site.xml

# Cria e ajusta permissões dos arquivos de log
touch /var/log/hive-metastore.log /var/log/hiveserver2.log /var/log/flume.log
chown hadoop:hadoop /var/log/hive-metastore.log /var/log/hiveserver2.log /var/log/flume.log

# Inicializa o esquema do Hive Metastore no MySQL
su - hadoop -c "schematool -initSchema -dbType mysql --verbose"

# Inicia o Hive Metastore
su - hadoop -c "hive --service metastore > /var/log/hive-metastore.log 2>&1 &"
su - hadoop -c "hive --service hiveserver2 > /var/log/hiveserver2.log 2>&1 &"


su - hadoop -c "$SPARK_HOME/sbin/start-history-server.sh"

su - hadoop -c "flume-ng agent -n agent -f /opt/flume/conf/flume.conf > /var/log/flume.log 2>&1 &"

# Inicia serviços básicos
service ssh start
service mysql start
mysqld_safe &

# Mantém o container ativo
tail -f /dev/null &

#beeline -u jdbc:hive2://localhost:10000 -n hadoop