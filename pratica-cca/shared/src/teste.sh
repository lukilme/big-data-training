wget https://repo1.maven.org/maven2/org/apache/avro/avro/1.8.2/avro-1.8.2.jar
wget https://repo1.maven.org/maven2/org/apache/avro/avro-mapred/1.8.2/avro-mapred-1.8.2-hadoop2.jar

cp avro-1.8.2.jar $SQOOP_HOME/lib/
cp avro-mapred-1.8.2-hadoop2.jar $SQOOP_HOME/lib/

/opt/sqoop/bin/sqoop import \
  --connect jdbc:mysql://localhost:3306/retail_db \
  --username root \
  --password root \
  --table departments \
  --target-dir /user/employees/data/departments \
  --class-name DepartmentsClass \
  --bindir /tmp/sqoop-classes
  
   
/opt/sqoop/bin/sqoop import \
  --connect jdbc:mysql://localhost:3306/retail_db \
  --username root \
  --password root \
  --table departments \
  --target-dir /user/shared/src/departments \
  --delete-target-dir \
  --direct