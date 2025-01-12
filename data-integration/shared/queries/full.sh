# Criação do arquivo com dados em formato CSV
echo "1,Produto A,10,150.50" > vendas.csv
echo "2,Produto B,5,200.00" >> vendas.csv
echo "3,Produto C,7,120.75" >> vendas.csv
echo "4,Produto D,12,350.00" >> vendas.csv
echo "5,Produto E,20,99.99" >> vendas.csv

# Carregar o arquivo para o HDFS no caminho especificado
hadoop fs -put vendas.csv /user/hive/data
