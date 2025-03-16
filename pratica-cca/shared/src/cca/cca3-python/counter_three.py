from pyspark import SparkContext
from pyspark.sql import SparkSession

sc = SparkContext("local","WordCount")
spark = SparkSession(sc)

filter_words = {"a","the","an","as","with","this","these","is","are","in","for","to","and","The","of"}

files_rdd = sc.textFile("hdfs://namenode:9000/spark/file1.txt,hdfs://namenode:9000/spark/file2.txt,hdfs://namenode:9000/spark/file3.txt")

word_counts = files_rdd.flatMap(lambda line: line.split(" ")).filter(lambda word: word not in filter_words).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)

print(word_counts)

sorted_word_counts = word_counts.sortBy(lambda x: x[1], ascending=False)

print("="*10)
print("sorted_word_counts")

sorted_word_counts.saveAsTextFile("hdfs://namenode:9000/spark/result_final", compressionCodecClass="org.apache.hadoop.io.compress.GzipCodec")

sc.stop()
