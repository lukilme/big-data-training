#!/bin/bash

HADOOP_HOME="/opt/hadoop"
HIVE_HOME="/opt/hive"
SQOOP_HOME="/opt/sqoop"
MYSQL_USER="hive"
MYSQL_PASSWORD="hive"
MYSQL_DB="hive"

sudo chown -R hadoop:hadoop $HADOOP_HOME $HIVE_HOME $SQOOP_HOME
sudo chmod -R 755 $HADOOP_HOME $HIVE_HOME $SQOOP_HOME

USER=$(whoami)
echo "Usuário atual: $USER"

$HIVE_HOME/bin/schematool -dbType mysql -info
if [ $? -ne 0 ]; then
    echo "Erro ao testar a conexão do Metastore. Verifique as configurações no hive-site.xml."
    exit 1
fi

mysql -u $MYSQL_USER -p $MYSQL_PASSWORD -e "USE $MYSQL_DB;"
if [ $? -ne 0 ]; then
    echo "Erro ao acessar o banco de dados MySQL. Verifique as credenciais no hive-site.xml."
    exit 1
fi

$HIVE_HOME/bin/schematool -initSchema -dbType mysql
if [ $? -ne 0 ]; then
    echo "Erro ao inicializar o esquema do Metastore. Verifique os logs."
    exit 1
fi

hive -e "SHOW DATABASES;"
if [ $? -ne 0 ]; then
    echo "Erro ao executar o comando Hive. Verifique os logs em $HIVE_HOME/logs."
    exit 1
fi

mysql -u hive

