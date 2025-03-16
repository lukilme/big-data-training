from pyspark import SparkContext
from pyspark.sql import SparkSession

sc = SparkContext("local","User")

user = sc.textFile("hdfs://namenode:9000/spark/user.csv")

user_no_header = user.zipWithIndex().filter(lambda line: line[1] > 0 and not line[0].startswith("myself")).map(lambda x:{
        "id": x[0].split(",")[0],
        "topic": x[0].split(",")[1],
        "hits": int(x[0].split(",")[2])
    })

user_no_header.saveAsTextFile("hdfs://namenode:9000/spark/no_header")

user_no_header.collect()

sc.stop()

