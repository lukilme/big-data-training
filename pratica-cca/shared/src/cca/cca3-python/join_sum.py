from pyspark import SparkContext

sc = SparkContext("local", "Join_Sum")

file1 = sc.textFile("hdfs://namenode:9000/spark/file1.txt")
file2 = sc.textFile("hdfs://namenode:9000/spark/file2.txt")

file1_map = file1.map(lambda line: (int(line.split(",")[0]), 
    (int(line.split(",")[1]), int(line.split(",")[2]))))


file2_map = file2.map(lambda line: (int(line.split(",")[0]), 
    (line.split(",")[1], line.split(",")[2])))

joined_all = file1_map.join(file2_map)

sum = joined_all.map(lambda x: x[1][0][1]).reduce(lambda a,b:a+b)

print(sum)

sc.stop()