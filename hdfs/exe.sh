#testing if is working
hdfs dfs -help
#to list directories with their permissions, user and group
hdfs dfs -ls 
#find java locate
sudo find / -name java
#edit bashrc, if necessary
vi ~/.bashrc
source ~/.bashrc

#creating new directory
hdfs dfs -mkdir /usr/stu01

vi stu1.txt
hdfs dfs -put stu01.txt stu01/

