rm -rf $HIVE_HOME
wget https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz -O /tmp/hive.tar.gz
tar -xzf /tmp/hive.tar.gz -C /opt
mv /opt/apache-hive-$HIVE_VERSION-bin $HIVE_HOME
rm -rf /tmp/*