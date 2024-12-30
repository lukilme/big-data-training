#!/bin/bash

export HADOOP_HOME=/usr/local/hadoop
export HDFS_NAMENODE_USER=hadoop
export HDFS_DATANODE_USER=hadoop
export HDFS_SECONDARYNAMENODE_USER=hadoop
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "Configuração do Hadoop e Java definidas."

echo "Ajustando permissões do diretório Hadoop..."
chown -R hadoop:hadoop $HADOOP_HOME/

echo "Configurando hadoop-env.sh..."
HADOOP_ENV="$HADOOP_HOME/etc/hadoop/hadoop-env.sh"
if [ ! -f "$HADOOP_ENV" ]; then
    touch "$HADOOP_ENV"
fi
echo "export JAVA_HOME=$JAVA_HOME" > "$HADOOP_ENV"

echo "Carregando as variáveis de ambiente..."
source ~/.bashrc

echo "Instalando e configurando SSH..."
apt update && apt install -y openssh-client openssh-server || { echo "Erro ao instalar o SSH"; exit 1; }

echo "Iniciando serviço SSH..."
service ssh start || { echo "Erro ao iniciar o SSH"; exit 1; }

echo "Configurando autenticação sem senha para SSH..."
su - hadoop -c "
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa ~/.ssh/authorized_keys
"

echo "Atualizando configurações de SSH no sshd_config..."
SSHD_CONFIG="/etc/ssh/sshd_config"
if ! grep -q "PubkeyAuthentication yes" "$SSHD_CONFIG"; then
    echo "PubkeyAuthentication yes" >> "$SSHD_CONFIG"
fi
chown -R hadoop:hadoop /tmp/hadoop-hadoop/dfs
chmod -R 700 /tmp/hadoop-hadoop/dfs
hadoop chmod 700 /home/hadoop/.ssh
hadoop chmod 600 /home/hadoop/.ssh/authorized_keys
echo "Reiniciando serviço SSH..."
service ssh restart || { echo "Erro ao reiniciar o SSH"; exit 1; }

# echo "Testando conexão SSH com localhost..."
# ssh -o StrictHostKeyChecking=no localhost exit || { echo "Erro ao configurar autenticação SSH"; exit 1; }

# echo "Setup do Hadoop concluído com sucesso!"


hadoop cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys