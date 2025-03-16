from pyspark import SparkContext

if __name__ == "__main__":
    sc = SparkContext("local", "CountLetters")

    input_path = "hdfs://namenode:9000/spark/file1.txt"
    output_path = "hdfs://namenode:9000/spark/result1.txt"

    lines = sc.textFile(input_path)

    letter_counts = lines.flatMap(lambda line: list(line.lower())).filter(lambda char: char.isalpha()).map(lambda letter: (letter, 1)).reduceByKey(lambda a, b: a + b)            # Soma as ocorrências de cada letra

    letter_counts.saveAsTextFile(output_path)

    sc.stop()
