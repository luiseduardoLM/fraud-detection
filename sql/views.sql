
-- Vistas 

USE paysim_fraud;

-- Vista de fraude vs no fraude

CREATE OR REPLACE VIEW vw_fraude_resumen AS
SELECT 
    isFraud,
    COUNT(*) AS total_transacciones,
    SUM(amount) AS total_monto,
    AVG(amount) AS promedio_monto,
    MIN(amount) AS min_monto,
    MAX(amount) AS max_monto
FROM paysim_data
GROUP BY isFraud;

SELECT * FROM vw_fraude_resumen;

-- Vista por tipo de transacción 

CREATE OR REPLACE VIEW vw_tipo_transaccion AS
SELECT 
    type,
    COUNT(*) AS total,
    SUM(amount) AS monto_total,
    AVG(amount) AS monto_promedio,
    SUM(isFraud) AS fraudes
FROM paysim_data
GROUP BY type;

SELECT * FROM vw_tipo_transaccion;

-- Vista de patrones de fruade 

CREATE OR REPLACE VIEW vw_patrones_fraude AS
SELECT 
    id,
    amount,
    oldbalanceOrg,
    newbalanceOrig,
    oldbalanceDest,
    newbalanceDest,
    isFraud,
    -- Patrón 1: cuenta vaciada
    CASE 
        WHEN oldbalanceOrg > 0 AND newbalanceOrig = 0 THEN 1 
        ELSE 0 
    END AS cuenta_vaciada,
    -- Patrón 2: destinatario nuevo
    CASE 
        WHEN oldbalanceDest = 0 THEN 1 
        ELSE 0 
    END AS dest_nuevo,
    -- Patrón 3: monto igual al saldo inicial
    CASE 
        WHEN amount = oldbalanceOrg THEN 1 
        ELSE 0 
    END AS transferencia_total

FROM paysim_data
WHERE isfraud = 1;

SELECT * FROM vw_patrones_fraude;