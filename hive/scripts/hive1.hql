-- Criar os bancos de dados
CREATE DATABASE IF NOT EXISTS ods_msg;
CREATE DATABASE IF NOT EXISTS dws_msg;
CREATE DATABASE IF NOT EXISTS ads_msg;

-- Usar o banco de dados ODS
USE ods_msg;

-- Criar a tabela msg_source (ajuste a estrutura conforme a descrição dos dados)
CREATE TABLE IF NOT EXISTS msg_source (
    message_id STRING,
    sender_id STRING,
    receiver_id STRING,
    message_content STRING,
    send_time TIMESTAMP,
    message_type STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','  -- ou outro delimitador conforme seus dados
STORED AS TEXTFILE;

-- Carregar dados do HDFS para a tabela Hive
LOAD DATA INPATH '/caminho/para/dados/no/hdfs' INTO TABLE msg_source;

SHOW DATABASES;

DESCRIBE FORMATTED ods_msg.msg_source;
-- ou
DESCRIBE ods_msg.msg_source;

SELECT * FROM ods_msg.msg_source LIMIT 5;

SELECT COUNT(*) FROM ods_msg.msg_source;

-- Usar o banco de dados DWS
USE dws_msg;

-- Criar a nova tabela com os dados transformados
CREATE TABLE IF NOT EXISTS msg_etl AS
SELECT 
    message_id,
    sender_id,
    receiver_id,
    message_content,
    -- Extrair a data no formato yyyy-MM-dd
    DATE(send_time) AS message_date,
    -- Extrair a hora
    HOUR(send_time) AS message_hour,
    -- Extrair latitude do campo GPS (ajuste o padrão conforme seus dados)
    -- Assumindo que GPS está no formato "latitude,longitude"
    SPLIT_PART(GPS, ',', 1) AS latitude,
    -- Extrair longitude do campo GPS
    SPLIT_PART(GPS, ',', 2) AS longitude,
    message_type
FROM 
    ods_msg.msg_source
WHERE 
    -- Filtrar registros onde GPS não está vazio
    GPS IS NOT NULL 
    AND TRIM(GPS) != ''
    -- Verificar se o campo GPS tem o formato esperado (contém vírgula)
    AND INSTR(GPS, ',') > 0;

SELECT * FROM dws_msg.msg_etl LIMIT 5;

-- Verificar se as partes extraídas são números válidos
AND REGEXP_REPLACE(SPLIT_PART(GPS, ',', 1), '[^0-9.-]', '') = SPLIT_PART(GPS, ',', 1)
AND REGEXP_REPLACE(SPLIT_PART(GPS, ',', 2), '[^0-9.-]', '') = SPLIT_PART(GPS, ',', 2)

CAST(SPLIT_PART(GPS, ',', 1) AS DOUBLE) AS latitude,
CAST(SPLIT_PART(GPS, ',', 2) AS DOUBLE) AS longitude,


USE ads_msg;

CREATE TABLE IF NOT EXISTS msg_cnt AS
SELECT 
    message_date,
    COUNT(*) AS total_messages
FROM 
    dws_msg.msg_etl
GROUP BY 
    message_date
ORDER BY 
    message_date;

-- Screenshot 5-1-1msg-cnt
SELECT * FROM msg_cnt;


CREATE TABLE IF NOT EXISTS msg_hour_cnt AS
SELECT 
    message_date,
    message_hour,
    COUNT(*) AS total_messages,
    COUNT(DISTINCT sender_id) AS sender_count,
    COUNT(DISTINCT receiver_id) AS recipient_count
FROM 
    dws_msg.msg_etl
GROUP BY 
    message_date, message_hour
ORDER BY 
    message_date, message_hour;

-- Screenshot 5-1-2-msg-hour
SELECT * FROM msg_hour_cnt LIMIT 20; -- Mostrar primeiras 20 linhas para visualização


CREATE TABLE IF NOT EXISTS msg_usr_cnt AS
SELECT 
    COUNT(DISTINCT sender_id) AS unique_senders,
    COUNT(DISTINCT receiver_id) AS unique_recipients
FROM 
    dws_msg.msg_etl
WHERE 
    message_date = '2023-01-01';

-- Screenshot 5-1-3msg-usr
SELECT * FROM msg_usr_cnt;

CREATE TABLE IF NOT EXISTS msg_usr_top10 AS
SELECT 
    sender_id,
    COUNT(*) AS messages_sent
FROM 
    dws_msg.msg_etl
GROUP BY 
    sender_id
ORDER BY 
    messages_sent DESC
LIMIT 10;

-- Screenshot 5-1-4msg-top10
SELECT * FROM msg_usr_top10;

-- Assumindo que phone_type pode ser extraído do sender_id ou há um campo separado
-- Este é um exemplo genérico - ajuste conforme sua estrutura de dados real
CREATE TABLE IF NOT EXISTS msg_sender_phone AS
SELECT 
    CASE 
        WHEN sender_id LIKE 'android%' THEN 'Android'
        WHEN sender_id LIKE 'iphone%' THEN 'iPhone'
        WHEN sender_id LIKE 'web%' THEN 'Web'
        ELSE 'Other'
    END AS phone_type,
    COUNT(*) AS count
FROM 
    dws_msg.msg_etl
GROUP BY 
    CASE 
        WHEN sender_id LIKE 'android%' THEN 'Android'
        WHEN sender_id LIKE 'iphone%' THEN 'iPhone'
        WHEN sender_id LIKE 'web%' THEN 'Web'
        ELSE 'Other'
    END;

-- Screenshot 5-1-5msg-phone
SELECT * FROM msg_sender_phone;

SELECT * FROM table_name LIMIT 10;