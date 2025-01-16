/opt/sqoop/bin/sqoop import \
  --connect jdbc:mysql://localhost:3306/employees \
  --username hive \
  --password hive \
  --table departments \
  --target-dir /user/employees/data/departments \
  --split-by dept_no \
  --class-name DepartmentsClass \
  --bindir /tmp/sqoop-classes 