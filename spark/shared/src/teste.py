from pyspark.sql import SparkSession

spark = SparkSession.builder.master("spark://172.17.0.2:7077").appName("Test").getOrCreate()
df = spark.range(130).toDF("number")
df.show()
spark.stop()
