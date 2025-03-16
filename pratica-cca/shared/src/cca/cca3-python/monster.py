from pyspark.sql import SparkSession
from datetime import datetime
from pyspark.sql.functions import udf
from pyspark.sql.types import BooleanType

def check(date):
    if not date:
        return False
    
    date = date.strip()

    for date_format in _date_formats:
        try:
            datetime.strip(date, date_format)
            return True
        except ValueError:
            continue
    return False
def extract_souls(line):
    try:
        match = re.search(r'\[(.*?)\]',line)
        if match:
            return match.group(1)
        return None
    except:
        return None

validated = udf(check, BooleanType())
extract = udf(extract_souls)

spark = SparkSession.builder \
    .appName("FilterDates") \
    .getOrCreate()

file = spark.read.text("hdfs://namenode:9000/spark/feadback.txt")
file_date =  file.withColumn("extracted_date", extract(file.value))

good_records = file_date.filter(validated(file_date.extracted_date))
bad_records = file_date.filter(~validated(file_date.extracted_date))

good_records.select("value").write.text("hdfs://namenode:9000/spark/good_records")
bad_records.select("value").write.text("hdfs://namenode:9000/spark/bad_records")


print(f"Registros válidos: {good_records.count()}")
print(f"Registros inválidos: {bad_records.count()}")

# Parar a sessão
spark.stop()