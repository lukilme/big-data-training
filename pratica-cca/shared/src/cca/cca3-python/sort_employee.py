from pyspark import SparkContext


sc = SparkContext("local", "SortEmployee")

employees = sc.textFile("hdfs://namenode:9000/spark/EmployeeName.csv")

sorted_employees = employees.map(lambda line: (line.split(',')[1], line.split(",")[0])).sortByKey()

sorted_employees.map(lambda line: f"({line[0]}, {line[1]})").coalesce(1).saveAsTextFile("hdfs://namenode:9000/spark/EmployeeSorted")

sc.stop()