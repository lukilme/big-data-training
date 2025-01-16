docker cp ./assignment_create_table_2018.txt hive-server2:/opt/hive/
docker exec -it hive-server2 bash 
# inside of hive-server2
hadoop fs -put ./assignment_create_table_2018.txt  /user/hive/warehouse
cp /opt/hive/assignment_create_table_2018.txt /opt/hive/metastore_db
