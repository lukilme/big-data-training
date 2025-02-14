wget https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar -P $SQOOP_HOME/lib/
wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar -P $SQOOP_HOME/lib/

cat <<EOF >> /etc/profile
export SQOOP_HOME=/opt/sqoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_COMMON_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export PATH=$PATH:$SQOOP_HOME/bin
export CLASSPATH=$SQOOP_HOME/lib/*:$HADOOP_HOME/lib/*:$HADOOP_HOME/share/hadoop/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/client/*
export CLASSPATH=/opt/sqoop/lib/*:/opt/hadoop/lib/*:/opt/hadoop/share/hadoop/client/*
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar
EOF
source /etc/profile