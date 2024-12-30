#!/bin/bash
useradd -m hadoop
passwd hadoop
useradd -m -s /bin/bash hadoop
passwd hadoop
chown -R hadoop:hadoop /usr/local/hadoop

export HADOOP_HOME=/usr/local/hadoop
export HDFS_NAMENODE_USER=hadoop
export HDFS_DATANODE_USER=hadoop
export HDFS_SECONDARYNAMENODE_USER=hadoop
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "Configuração do Hadoop e Java definidas."

echo "Ajustando permissões do diretório Hadoop..."
chown -R root:root $HADOOP_HOME/

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
if [ ! -d "/root/.ssh" ]; then
    mkdir /root/.ssh
    chmod 700 /root/.ssh
fi

if [ ! -f "/root/.ssh/id_rsa" ]; then
    ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa
fi

if [ ! -f "/root/.ssh/authorized_keys" ]; then
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Atualizando configurações de SSH no sshd_config..."
SSHD_CONFIG="/etc/ssh/sshd_config"
if ! grep -q "PubkeyAuthentication yes" "$SSHD_CONFIG"; then
    echo "PubkeyAuthentication yes" >> "$SSHD_CONFIG"
fi

echo "Reiniciando serviço SSH..."
service ssh restart || { echo "Erro ao reiniciar o SSH"; exit 1; }
