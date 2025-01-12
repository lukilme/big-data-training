/opt/sqoop/bin/sqoop import \
  --connect jdbc:mysql://localhost:3306/employees \
  --username retail_dba \
  --password cloudera \
  --table departments \
  --target-dir /user/cloudera/employees_db/data \
  --split-by dept_no \
  --class-name DepartmentsClass \
  --bindir /tmp/sqoop-classes