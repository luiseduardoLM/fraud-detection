USE paysim_fraud;

SELECT * FROM paysim_data LIMIT 10;

# Total de transacciones, monto total y promedio de monto por transacción
SELECT 
	COUNT(*) AS total_transacciones,
    SUM(amount) AS monto_total,
	ROUND(AVG(amount), 2) AS monto_promedio_por_transacción
FROM paysim_data;

# Tipos de transacción y número de transacciones por tipo
SELECT 
	type,
    COUNT(type) AS número_transacciones_por_tipo
FROM paysim_data
GROUP BY type;