from pyspark import SparkContext
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Employee").getOrCreate()

names_df = spark.read.csv("hdfs://namenode:9000/spark/EmployeeName.csv", header=False)
names_df = names_df.toDF("id", "name")

salaries_df = spark.read.csv("hdfs://namenode:9000/spark/EmployeeSalary.csv", header=False)
salaries_df = salaries_df.toDF("id", "salary")
salaries_df = salaries_df.withColumn("salary", salaries_df["salary"].cast("int"))

joined_df = names_df.join(salaries_df, "id")

joined_df.createOrReplaceTempView("employees")
for row in spark.sql("SELECT DISTINCT salary FROM employees").collect():
    salary = row["salary"]
    spark.sql(f"SELECT name FROM employees WHERE salary = {salary}") \
         .write.text(f"hdfs://namenode:9000/spark/output/salary_{salary}")

spark.stop()
