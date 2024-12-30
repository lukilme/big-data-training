from pyspark import SparkContext

# Criar o contexto do Spark
sc = SparkContext("local", "Word Count")

# Ler um arquivo de texto
text_file = sc.textFile("hdfs://localhost:9000/input.txt")

# Contar palavras
counts = (text_file
          .flatMap(lambda line: line.split(" "))
          .map(lambda word: (word, 1))
          .reduceByKey(lambda a, b: a + b))

# Salvar o resultado
counts.saveAsTextFile("hdfs://localhost:9000/output.txt")
