USE paysim_fraud;

SELECT * FROM paysim_data LIMIT 10;

# Total de transacciones, monto total y promedio de monto por transacción
SELECT 
	COUNT(*) AS total_transacciones,
    SUM(amount) AS monto_total,
	ROUND(AVG(amount), 2) AS monto_promedio_por_transacción
FROM paysim_data;

# Tipos de transacción, número de transacciones y promedio por tipo
SELECT 
	type,
    COUNT(type) AS número_transacciones_por_tipo,
    ROUND(AVG(amount), 2) AS monto_promedio_por_tipo
FROM paysim_data
GROUP BY type;

-- ¿Cuantas transacciones son fraude por tipo?
SELECT 
	type,
	COUNT(isfraud) AS total_fraudes
FROM paysim_data
WHERE isfraud = 1
GROUP BY type;

-- Estadisticas de fraudes
SELECT
	isfraud,
	ROUND(AVG(amount), 2) AS monto_promedio,
    MAX(amount) AS monto_maximo,
    MIN(amount) AS monto_minimo
FROM paysim_data
GROUP BY isfraud;


-- ¿Los fraudes vacían completamente la cuenta? ¿El dinero se envia a cuentas vacias?
SELECT
	oldbalanceOrg,
    amount,
    newbalanceOrig,
    oldbalanceDest,
    newbalanceDest
FROM paysim_data
WHERE isfraud=1;
    
-- Vemos que gran mayoria de lso fraudes suceden cuando se vacia completamente uan cuenta. 