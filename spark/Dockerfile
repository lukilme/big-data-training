FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    curl \
    tar \
    unzip \
    net-tools \
    vim \
    openssh-client \
    openssh-server \
    && apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

ENV HADOOP_VERSION=3.3.6
RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
    && tar -xzf hadoop-$HADOOP_VERSION.tar.gz -C /usr/local/ \
    && rm hadoop-$HADOOP_VERSION.tar.gz \
    && mv /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

ENV HIVE_VERSION=4.0.1
RUN wget https://archive.apache.org/dist/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz \
    && tar -xzf apache-hive-$HIVE_VERSION-bin.tar.gz -C /usr/local/ \
    && rm apache-hive-$HIVE_VERSION-bin.tar.gz \
    && mv /usr/local/apache-hive-$HIVE_VERSION-bin /usr/local/hive
ENV HIVE_HOME=/usr/local/hive
ENV PATH=$HIVE_HOME/bin:$PATH

ENV HBASE_VERSION=2.6.1
RUN wget https://dlcdn.apache.org/hbase/2.6.1/hbase-2.6.1-bin.tar.gz \
    && tar -xzf hbase-$HBASE_VERSION-bin.tar.gz -C /usr/local/ \
    && rm hbase-$HBASE_VERSION-bin.tar.gz \
    && mv /usr/local/hbase-$HBASE_VERSION /usr/local/hbase
ENV HBASE_HOME=/usr/local/hbase
ENV PATH=$HBASE_HOME/bin:$PATH

ENV SPARK_VERSION=3.5.3
RUN wget https://dlcdn.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz \
    && tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz -C /usr/local/ \
    && rm spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && mv /usr/local/spark-$SPARK_VERSION-bin-hadoop3 /usr/local/spark
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

ENV ZOOKEEPER_VERSION=3.8.2
RUN wget https://dlcdn.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz \
    && tar -xzf apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz -C /usr/local/ \
    && rm apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz \
    && mv /usr/local/apache-zookeeper-$ZOOKEEPER_VERSION-bin /usr/local/zookeeper
ENV ZOOKEEPER_HOME=/usr/local/zookeeper
ENV PATH=$ZOOKEEPER_HOME/bin:$PATH
RUN mkdir -p $ZOOKEEPER_HOME/data \
    && echo "tickTime=2000" > $ZOOKEEPER_HOME/conf/zoo.cfg \
    && echo "dataDir=$ZOOKEEPER_HOME/data" >> $ZOOKEEPER_HOME/conf/zoo.cfg \
    && echo "clientPort=2181" >> $ZOOKEEPER_HOME/conf/zoo.cfg

COPY shared/config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY shared/config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY shared/config/hive-site.xml $HIVE_HOME/conf/hive-site.xml
COPY shared/config/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

EXPOSE 8088 50070 10000 16010 4040 9000 4040 7077 8080 2181

CMD ["/bin/bash"]
