from pyspark import SparkContext

sc = SparkContext("local", "Word Count")


text_file = sc.textFile("hdfs://localhost:9000/input.txt")

counts = (text_file
          .flatMap(lambda line: line.split(" "))
          .map(lambda word: (word, 1))
          .reduceByKey(lambda a, b: a + b))


counts.saveAsTextFile("hdfs://localhost:9000/output")
