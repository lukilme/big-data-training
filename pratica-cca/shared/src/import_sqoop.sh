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

/opt/hadoop/bin/hdfs dfs -mkdir -p /user/shared/src/departments
/opt/hadoop/bin/hdfs dfs -mkdir -p /temp
/opt/hadoop/bin/hdfs dfs -chmod -R 777 /user/shared/src/
/opt/hadoop/bin/hdfs dfs -chmod 777 /tmp


/opt/sqoop/bin/sqoop import \
  --connect jdbc:mysql://localhost:3306/retail_db \
  --username root \
  --password root \
  --table departments \
  --target-dir hdfs:///user/shared/src/departments \
  --split-by id \
  --driver com.mysql.cj.jdbc.Driver \
  --delete-target-dir \
  -m 1