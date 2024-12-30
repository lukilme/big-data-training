CREATE DATABASE retail_db;
CREATE USER 'retail_dba'@'%' IDENTIFIED BY 'cloudera';
GRANT ALL PRIVILEGES ON retail_db.* TO 'retail_dba'@'%';
FLUSH PRIVILEGES;