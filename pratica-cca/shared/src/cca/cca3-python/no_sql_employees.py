from pyspark import SparkContext
from pyspark.sql import SparkSession
from pyspark.sql.functions import col


sc = SparkContext(appName="Employee")
spark = SparkSession(sc)

names_rdd = sc.textFile("hdfs://namenode:9000/spark/EmployeeName.csv")
names_rdd = names_rdd.map(lambda line: line.split(","))

salaries_rdd = sc.textFile("hdfs://namenode:9000/spark/EmployeeSalary.csv")
salaries_rdd = salaries_rdd.map(lambda line: line.split(","))
salaries_rdd = salaries_rdd.map(lambda x: (x[0], int(x[1])))  

joined_rdd = names_rdd.map(lambda x: (x[0], x[1])).join(salaries_rdd)

df = spark.createDataFrame(joined_rdd.map(lambda x: (x[0], x[1][0], x[1][1])), ["id", "name", "salary"])

salaries = df.select("salary").distinct().rdd.map(lambda row: row["salary"]).collect()

for salary in salaries:
    names = df.filter(col("salary") == salary).select("name").rdd.map(lambda row: row["name"]).collect()
    path = f"hdfs://namenode:9000/spark/output1/salary_{salary}"
    rdd = sc.parallelize(names)
    rdd.saveAsTextFile(path)

sc.stop()
