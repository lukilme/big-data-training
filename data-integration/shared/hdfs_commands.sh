echo "Criando diretório /user/stu01 no HDFS"
hdfs dfs -mkdir -p /user/stu01

echo "Criando arquivo stu01.txt"
vim stu01.txt

echo "Enviando stu01.txt para o HDFS em /user/stu01/"
hdfs dfs -put stu01.txt /user/stu01/

echo "Exibindo conteúdo de stu01.txt no HDFS"
hdfs dfs -cat /user/stu01/stu01.txt

echo "Criando arquivo stu02.txt"
vim stu02.txt

echo "Movendo stu02.txt para o HDFS em /user/stu01/"
hdfs dfs -moveFromLocal stu02.txt /user/stu01/

echo "Criando arquivo stu03.txt"
vim stu03.txt

echo "Exibindo conteúdo de stu03.txt localmente"
cat stu03.txt

echo "Exibindo conteúdo de stu02.txt no HDFS antes de adicionar dados"
hdfs dfs -cat /user/stu01/stu02.txt

echo "diferença entre o antes e depois:"

echo "Adicionando conteúdo de stu03.txt ao stu02.txt no HDFS"
hdfs dfs -appendToFile stu03.txt /user/stu01/stu02.txt

echo "Exibindo conteúdo de stu02.txt após adicionar dados"
hdfs dfs -cat /user/stu01/stu02.txt

echo "Criando arquivo stu04.txt"
vim stu04.txt

echo "Exibindo conteúdo de stu04.txt localmente"
cat stu04.txt

echo "Enviando stu04.txt para o HDFS em /user/stu01/"
hdfs dfs -put stu04.txt /user/stu01/

echo "Listando arquivos no diretório /user/stu01/"
hdfs dfs -ls /user/stu01/

echo "Criando diretório /user/stu02/ no HDFS"
hdfs dfs -mkdir /user/stu02/

echo "Copiando stu04.txt de /user/stu01/ para /user/stu02/"
hdfs dfs -cp /user/stu01/stu04.txt /user/stu02/

echo "Criando arquivo stu05.txt"
vim stu05.txt

echo "Exibindo conteúdo de stu05.txt localmente"
cat stu05.txt

echo "Enviando stu05.txt para o HDFS em /user/stu01/"
hdfs dfs -put stu05.txt /user/stu01/

echo "Movendo stu05.txt de /user/stu01/ para /user/stu02/"
hdfs dfs -mv /user/stu01/stu05.txt /user/stu02/

echo "Copiando stu05.txt do HDFS para o diretório local"
hdfs dfs -copyToLocal /user/stu02/stu05.txt

echo "Mesclando arquivos de /user/stu01/ em merge.txt localmente"
hdfs dfs -getmerge /user/stu01/* ./merge.txt

echo "Listando arquivos no diretório /user/stu02/"
hdfs dfs -ls /user/stu02/

echo "diferença entre o antes e depois:"

echo "Removendo stu05.txt de /user/stu02/"
hdfs dfs -rm /user/stu02/stu05.txt

echo "Listando arquivos no diretório /user/stu02/ após remoção"
hdfs dfs -ls /user/stu02/

echo "Verificando uso de espaço no HDFS"
hdfs dfs -df -h /

echo "Verificando uso de espaço no diretório /user/stu01/"
hdfs dfs -du -s -h /user/stu01

echo "Exibindo contagem detalhada de arquivos e diretórios em /user/stu01/"
hdfs dfs -count -v /user/stu01