CREATE DATABASE IF NOT EXISTS retail_db;

USE retail_db;

CREATE TABLE IF NOT EXISTS departments(
    id INT PRIMARY KEY,
    name VARCHAR(45) NOT NULL
);
INSERT INTO departments(id, name) VALUES
(10, 'physics'),
(11, 'Chemistry'),
(12, 'Maths'),
(13, 'Science'),
(14, 'Engineering');

SELECT * FROM departments;