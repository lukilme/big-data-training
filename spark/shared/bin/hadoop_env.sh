
echo "Iniciando a configuração do Hadoop..."

echo "Criando o usuário hadoop..."
useradd -m -s /bin/bash hadoop
echo "Defina a senha para o usuário hadoop:"
passwd hadoop

sh -c "echo '127.0.0.1 localhost namenode' >> /etc/hosts"

echo "Configurando variáveis de ambiente..."
export HADOOP_HOME=/usr/local/hadoop
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin:$PATH

echo "export HADOOP_HOME=$HADOOP_HOME" >> /etc/profile
echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile
echo "export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile

echo "Ajustando permissões do diretório Hadoop..."
chown -R hadoop:hadoop $HADOOP_HOME


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
EOL


echo "Instalando e configurando o SSH..."
apt update && apt install -y openssh-client openssh-server
service ssh start

echo "Configurando autenticação SSH sem senha..."
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


echo "Ajustando permissões no diretório HDFS..."
mkdir -p $HADOOP_HOME/tmp
chown -R hadoop:hadoop $HADOOP_HOME/tmp

# Teste de SSH
echo "Testando SSH para o usuário hadoop..."
su - hadoop -c "ssh localhost exit"

# Finalizando
echo "Configuração concluída. Você pode iniciar o Hadoop como o usuário 'hadoop' com os seguintes comandos:"
echo "  su - hadoop"
echo "  start-dfs.sh"
echo "  start-yarn.sh"