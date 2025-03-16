from pyspark import SparkContext

sc = SparkContext("local", "Cancat")

rdd1 = sc.parallelize([("a", [1, 2]), ("b", [1, 2])])
rdd2 = sc.parallelize([("a", [3]), ("b", [2])])

result = rdd1.union(rdd2) \
    .reduceByKey(lambda a, b: a + b)

result.saveAsTextFile("hdfs://namenode:9000/bolsafamilia")

result.collect()

sc.stop()