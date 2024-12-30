FROM openjdk:8-jdk

ENV HADOOP_VERSION=3.3.6 \
    HIVE_VERSION=4.0.1 \
    SQOOP_VERSION=1.4.7 \
    HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/hive \
    SQOOP_HOME=/opt/sqoop \
    PATH=$HADOOP_HOME/bin:$HIVE_HOME/bin:$SQOOP_HOME/bin:$PATH

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    tar \
    ssh \
    openssh-server \
    net-tools \
    procps \
    rsync \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O /tmp/hadoop.tar.gz && \
    tar -xzf /tmp/hadoop.tar.gz -C /opt && \
    mv /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm /tmp/hadoop.tar.gz

RUN wget https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz -O /tmp/hive.tar.gz && \
    tar -xzf /tmp/hive.tar.gz -C /opt && \
    mv /opt/apache-hive-$HIVE_VERSION-bin $HIVE_HOME && \
    rm /tmp/hive.tar.gz

RUN wget https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -O /tmp/sqoop.tar.gz && \
    tar -xzf /tmp/sqoop.tar.gz -C /opt && \
    mv /opt/sqoop-1.4.7.bin__hadoop-2.6.0 $SQOOP_HOME && \
    rm /tmp/sqoop.tar.gz

COPY ./shared/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY ./shared/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml

COPY ./shared/hive-site.xml $HIVE_HOME/conf/hive-site.xml

COPY ./shared/sqoop-site.xml $SQOOP_HOME/conf/sqoop-site.xml

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

EXPOSE 50070 8080 10000

CMD bash
