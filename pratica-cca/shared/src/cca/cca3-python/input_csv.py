from pyspark import SparkContext

sc = SparkContext("local", "SortByName")

csv = sc.textFile("hdfs://namenode:9000/spark/data.csv")

group = csv.map(lambda line : 
    (int(line.split(",")[0]), line.split(",")[1])).groupByKey()

group.map(lambda line: f"{line[0]},{','.join(line[1])}")
    .saveAsTextFile("hdfs://namenode:9000/results_01")

sc.stop()