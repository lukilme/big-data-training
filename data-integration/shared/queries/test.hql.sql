CREATE EXTERNAL TABLE vendas (
    id INT,
    produto STRING,
    quantidade INT,
    valor DECIMAL(10, 2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://namenode:9000/user/hive/data'; 