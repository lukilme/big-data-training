#!/bin/bash

service mysql start
hdfs namenode -format
start-dfs.sh
start-yarn.sh
hive --service metastore &
tail -f /dev/null