
-- Creamos el database donde se almacenara la tabla 
CREATE DATABASE IF NOT EXISTS paysim_fraud DEFAULT CHARACTER SET latin1;
USE paysim_fraud;							

-- Creamos la tabla incluyendo id como primary key
CREATE TABLE IF NOT EXISTS paysim_data (
    id INT NOT NULL AUTO_INCREMENT,
    step INT,
    type VARCHAR(20),
    amount DECIMAL(20,2),
    nameOrig VARCHAR(30),
    oldbalanceOrg DECIMAL(20,2),
    newbalanceOrig DECIMAL(20,2),
    nameDest VARCHAR(30),
    oldbalanceDest DECIMAL(20,2),
    newbalanceDest DECIMAL(20,2),
    isFraud TINYINT(1),
    isFlaggedFraud TINYINT(1),
    PRIMARY KEY (id)
);

-- Esto me permite cargar el csv a la tabla creada
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- Cargamos el dataset a la tabla creada
LOAD DATA LOCAL INFILE 'C:/Users/luise/Desktop/PaySim_proyecto/data/PaySim_data.csv'
INTO TABLE paysim_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(step,type,amount,nameOrig,oldbalanceOrg,newbalanceOrig,
 nameDest,oldbalanceDest,newbalanceDest,isFraud,isFlaggedFraud);


-- Verificamos los datos nulos en todas las columnas
SELECT
    COUNT(*) - COUNT(step) AS step_nulls,
    COUNT(*) - COUNT(type) AS type_nulls,
    COUNT(*) - COUNT(amount) AS amount_nulls,
    COUNT(*) - COUNT(nameOrig) AS nameOrig_nulls,
    COUNT(*) - COUNT(oldbalanceOrg) AS oldbalanceOrg_nulls,
    COUNT(*) - COUNT(newbalanceOrig) AS newbalanceOrig_nulls,
    COUNT(*) - COUNT(nameDest) AS nameDest_nulls,
    COUNT(*) - COUNT(oldbalanceDest) AS oldbalanceDest_nulls,
    COUNT(*) - COUNT(newbalanceDest) AS newbalanceDest_nulls,
    COUNT(*) - COUNT(isFraud) AS isFraud_nulls,
    COUNT(*) - COUNT(isFlaggedFraud) AS isFlaggedFraud_nulls
FROM paysim_data;


-- Vista rapida de existencia de clientes repetidos 
SELECT COUNT(*) AS total_filas,
       COUNT(DISTINCT nameOrig) AS clientes_unicos
FROM paysim_data;


-- Query para revisar si existen filas duplicadas.
-- No es posible que la query compile, por lo que en Python verificaré si existen duplicados
SELECT step, type, amount, nameOrig, oldbalanceOrg,
       newbalanceOrig, nameDest, oldbalanceDest,
       newbalanceDest, isFraud, isFlaggedFraud,
       COUNT(*) AS cantidad
FROM paysim_data
GROUP BY step, type, amount, nameOrig, oldbalanceOrg,
         newbalanceOrig, nameDest, oldbalanceDest,
         newbalanceDest, isFraud, isFlaggedFraud
HAVING COUNT(*) > 1;