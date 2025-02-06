FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    netcat \
    mysql-server \
    python3 \
    python3-pip \
    openssh-server \
    sudo \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y openjdk-8-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_VERSION=3.3.6
ENV HIVE_VERSION=3.1.3
ENV FLUME_VERSION=1.11.0
ENV SPARK_VERSION=3.3.2
ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/hive
ENV FLUME_HOME=/opt/flume
ENV SPARK_HOME=/opt/spark
ENV PATH="${PATH}:${HADOOP_HOME}/bin:${HIVE_HOME}/bin:${FLUME_HOME}/bin:${SPARK_HOME}/bin"

RUN wget -q https://archive.apache.org/dist/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ \
    && ln -s /opt/hadoop-${HADOOP_VERSION} ${HADOOP_HOME} \
    && rm hadoop-${HADOOP_VERSION}.tar.gz

RUN wget -q https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && tar -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} \
    && rm apache-hive-${HIVE_VERSION}-bin.tar.gz

RUN wget -q https://archive.apache.org/dist/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz \
    && tar -xzf apache-flume-${FLUME_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-flume-${FLUME_VERSION}-bin ${FLUME_HOME} \
    && rm apache-flume-${FLUME_VERSION}-bin.tar.gz

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt/ \
    && ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
    && rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

COPY config/hadoop/* ${HADOOP_HOME}/etc/hadoop/

RUN mv ${HIVE_HOME}/conf/hive-default.xml.template ${HIVE_HOME}/conf/hive-site.xml
RUN schematool -initSchema -dbType derby

RUN service mysql start && \
    mysql -e "CREATE DATABASE retail_db; \
    CREATE USER 'retail_dba'@'%' IDENTIFIED BY 'cloudera'; \
    GRANT ALL PRIVILEGES ON retail_db.* TO 'retail_dba'@'%'; \
    FLUSH PRIVILEGES;"

RUN mkdir -p \
    /opt/gen_logs/logs \
    /home/cloudera/flumetest \
    /tmp/nrtcontent \
    /tmp/spooldir/bb \
    /tmp/spooldir/dr \
    /tmp/spooldir2 \
    /tmp/flume

COPY flume-configs/ ${FLUME_HOME}/conf/

COPY *.sh /opt/scripts/
COPY *.csv /opt/data/
COPY *.txt /opt/data/

RUN chmod +x /opt/scripts/*.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306 8020 8042 8088 8888 9083 10000

ENTRYPOINT ["/entrypoint.sh"]