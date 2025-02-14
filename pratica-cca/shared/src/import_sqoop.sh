#!/bin/bash


# sqoop import \
#   -Dmapred.child.java.opts="-Xlint:-deprecation" \
#   --connect jdbc:mysql://localhost:3306/retail_db \
#   --username root \
#   --password root \
#   --table departments \
#   -Dmapreduce.job.staging.dir=/user/root/sqoop_staging \
#   --target-dir /shared/src/departments \
#   --driver com.mysql.cj.jdbc.Driver \
#   --delete-target-dir \
#   -m 1

hdfs dfs -mkdir -p /user/shared/src/departments
hdfs dfs -chmod -R 777 /user/shared/src/
hdfs dfs -chmod 777 /tmp

sqoop import \
  --connect jdbc:mysql://localhost:3306/retail_db \
  --username user \
  --password password \
  --table departments \
  --target-dir hdfs:///user/shared/src/departments \
  --split-by id \
  --driver com.mysql.cj.jdbc.Driver \
  --delete-target-dir \
  -m 1