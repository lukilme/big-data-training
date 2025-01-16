echo -e "\e[34mCriando diretório /user/stu01 no HDFS\e[0m"
echo "hdfs dfs -mkdir -p /user/stu01"
hdfs dfs -mkdir -p /user/stu01

echo -e "\e[32mCriando arquivo stu01.txt\e[0m"
echo "vim stu01.txt"
vim stu01.txt

echo -e "\e[34mEnviando stu01.txt para o HDFS em /user/stu01/\e[0m"
echo "hdfs dfs -put stu01.txt /user/stu01/"
hdfs dfs -put stu01.txt /user/stu01/

echo -e "\e[33mExibindo conteúdo de stu01.txt no HDFS\e[0m"
echo "hdfs dfs -cat /user/stu01/stu01.txt"
hdfs dfs -cat /user/stu01/stu01.txt

echo -e "\e[32mCriando arquivo stu02.txt\e[0m"
echo "vim stu02.txt"
vim stu02.txt

echo -e "\e[34mMovendo stu02.txt para o HDFS em /user/stu01/\e[0m"
echo "hdfs dfs -moveFromLocal stu02.txt /user/stu01/"
hdfs dfs -moveFromLocal stu02.txt /user/stu01/

echo -e "\e[32mCriando arquivo stu03.txt\e[0m"
echo "vim stu03.txt"
vim stu03.txt

echo -e "\e[33mExibindo conteúdo de stu03.txt localmente\e[0m"
echo "cat stu03.txt"
cat stu03.txt

echo -e "\e[33mExibindo conteúdo de stu02.txt no HDFS antes de adicionar dados\e[0m"
echo "hdfs dfs -cat /user/stu01/stu02.txt"
hdfs dfs -cat /user/stu01/stu02.txt

echo -e "\e[35mdiferença entre o antes e depois:\e[0m"

echo -e "\e[34mAdicionando conteúdo de stu03.txt ao stu02.txt no HDFS\e[0m"
echo "hdfs dfs -appendToFile stu03.txt /user/stu01/stu02.txt"
hdfs dfs -appendToFile stu03.txt /user/stu01/stu02.txt

echo -e "\e[33mExibindo conteúdo de stu02.txt após adicionar dados\e[0m"
echo "hdfs dfs -cat /user/stu01/stu02.txt"
hdfs dfs -cat /user/stu01/stu02.txt

echo -e "\e[32mCriando arquivo stu04.txt\e[0m"
echo "vim stu04.txt"
vim stu04.txt

echo -e "\e[33mExibindo conteúdo de stu04.txt localmente\e[0m"
echo "cat stu04.txt"
cat stu04.txt

echo -e "\e[34mEnviando stu04.txt para o HDFS em /user/stu01/\e[0m"
echo "hdfs dfs -put stu04.txt /user/stu01/"
hdfs dfs -put stu04.txt /user/stu01/

echo -e "\e[36mListando arquivos no diretório /user/stu01/\e[0m"
echo "hdfs dfs -ls /user/stu01/"
hdfs dfs -ls /user/stu01/

echo -e "\e[34mCriando diretório /user/stu02/ no HDFS\e[0m"
echo "hdfs dfs -mkdir /user/stu02/"
hdfs dfs -mkdir /user/stu02/

echo -e "\e[34mCopiando stu04.txt de /user/stu01/ para /user/stu02/\e[0m"
echo "hdfs dfs -cp /user/stu01/stu04.txt /user/stu02/"
hdfs dfs -cp /user/stu01/stu04.txt /user/stu02/

echo -e "\e[32mCriando arquivo stu05.txt\e[0m"
echo "vim stu05.txt"
vim stu05.txt

echo -e "\e[33mExibindo conteúdo de stu05.txt localmente\e[0m"
echo "cat stu05.txt"
cat stu05.txt

echo -e "\e[34mEnviando stu05.txt para o HDFS em /user/stu01/\e[0m"
echo "hdfs dfs -put stu05.txt /user/stu01/"
hdfs dfs -put stu05.txt /user/stu01/

echo -e "\e[34mMovendo stu05.txt de /user/stu01/ para /user/stu02/\e[0m"
echo "hdfs dfs -mv /user/stu01/stu05.txt /user/stu02/"
hdfs dfs -mv /user/stu01/stu05.txt /user/stu02/

echo -e "\e[34mCopiando stu05.txt do HDFS para o diretório local\e[0m"
echo "hdfs dfs -copyToLocal /user/stu02/stu05.txt"
hdfs dfs -copyToLocal /user/stu02/stu05.txt

echo -e "\e[34mMesclando arquivos de /user/stu01/ em merge.txt localmente\e[0m"
echo "hdfs dfs -getmerge /user/stu01/* ./merge.txt"
hdfs dfs -getmerge /user/stu01/* ./merge.txt

echo -e "\e[36mListando arquivos no diretório /user/stu02/\e[0m"
echo "hdfs dfs -ls /user/stu02/"
hdfs dfs -ls /user/stu02/

echo -e "\e[31mRemovendo stu05.txt de /user/stu02/\e[0m"
echo "hdfs dfs -rm /user/stu02/stu05.txt"
hdfs dfs -rm /user/stu02/stu05.txt

echo -e "\e[36mVerificando uso de espaço no HDFS\e[0m"
echo "hdfs dfs -df -h /"
hdfs dfs -df -h /
