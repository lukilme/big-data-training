from pyspark import SparkContext
from pyspark.sql import SparkSession

sc = SparkContext("local","SequenceFile")

spark = SparkSession(sc)

rdd = sc.parallelize([bytearray([1, 2, 3]), bytearray([4, 5, 6])])

# rdd.map(lambda x: (None, bytearray(x))).saveAsSequenceFile("hdfs://namenode:9000/spark/sequenceFile", compressionCodecClass="org.apache.hadoop.io.compress.GzipCodec")
rdd.map(lambda x: (None, bytearray(x))).saveAsSequenceFile(
    "hdfs://namenode:9000/spark/sequenceFile"
)

sc.stop()