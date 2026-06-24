# Detección de Fraude en Transacciones Financieras con PaySim

Este proyecto analiza el dataset **PaySim**, un conjunto de datos sintético que simula transacciones financieras móviles. El objetivo principal es identificar patrones asociados al fraude y construir modelos de Machine Learning capaces de detectar transacciones fraudulentas.

El proyecto combina tres etapas principales:

1. **Carga y exploración inicial con SQL**
2. **Análisis exploratorio e ingeniería de variables con Python**
3. **Entrenamiento y evaluación de modelos de Machine Learning**

---

## Objetivo del proyecto

El objetivo es desarrollar un flujo completo de análisis de fraude financiero, desde la creación de una base de datos relacional hasta el entrenamiento de modelos predictivos.

En particular, el proyecto busca responder preguntas como:

- ¿Qué tipos de transacciones concentran los fraudes?
- ¿Los fraudes suelen ocurrir en montos altos?
- ¿Las transacciones fraudulentas vacían la cuenta de origen?
- ¿Qué variables ayudan más a distinguir entre fraude y no fraude?
- ¿Qué modelo funciona mejor para detectar fraudes en un dataset altamente desbalanceado?

---

## Dataset

El dataset utilizado es **PaySim**, el cual contiene transacciones financieras simuladas.

Cada fila representa una transacción y contiene información como:

| Columna | Descripción |
|---|---|
| `step` | Unidad de tiempo de la simulación |
| `type` | Tipo de transacción: `PAYMENT`, `TRANSFER`, `CASH_OUT`, `CASH_IN`, `DEBIT` |
| `amount` | Monto de la transacción |
| `nameOrig` | Identificador del cliente que origina la transacción |
| `oldbalanceOrg` | Saldo inicial del cliente origen |
| `newbalanceOrig` | Saldo final del cliente origen |
| `nameDest` | Identificador del destinatario |
| `oldbalanceDest` | Saldo inicial del destinatario |
| `newbalanceDest` | Saldo final del destinatario |
| `isFraud` | Variable objetivo: `1` si la transacción es fraude, `0` si no lo es |
| `isFlaggedFraud` | Indicador de transacción marcada como fraude por el sistema |

---

## Estructura del proyecto

```text
PaySim_proyecto/
│
├── notebooks/
│   └── main_notebook.ipynb
│
├── sql/
│   ├── create_database_table.sql
│   ├── eda_sql.sql
│   └── views.sql
│
└─── README.md
```
No incluyo la carpeta data debido a que el csv que ocupe es basante pesado. 

---

## Archivos principales

### `create_database_table.sql`

Script utilizado para crear la base de datos y la tabla principal en MySQL.

Incluye:

- Creación de la base de datos `paysim_fraud`
- Creación de la tabla `paysim_data`
- Carga del archivo CSV mediante `LOAD DATA LOCAL INFILE`
- Revisión de valores nulos
- Consulta para verificar clientes únicos
- Consulta para revisar posibles duplicados

---

### `eda_sql.sql`

Script con consultas SQL para realizar una primera exploración del dataset.

Incluye análisis de:

- Total de transacciones
- Monto total transaccionado
- Monto promedio por transacción
- Cantidad de transacciones por tipo
- Monto promedio por tipo de transacción
- Fraudes por tipo de transacción
- Estadísticas generales de fraudes
- Revisión de saldos en transacciones fraudulentas

---

### `views.sql`

Script que crea vistas para resumir y facilitar el análisis.

Vistas creadas:

| Vista | Descripción |
|---|---|
| `vw_fraude_resumen` | Resume transacciones fraudulentas y no fraudulentas |
| `vw_tipo_transaccion` | Resume transacciones por tipo |
| `vw_patrones_fraude` | Identifica patrones en transacciones fraudulentas |

La vista `vw_patrones_fraude` crea indicadores como:

- `cuenta_vaciada`: identifica si la cuenta origen termina en cero
- `dest_nuevo`: identifica si el destinatario no tenía saldo previo
- `transferencia_total`: identifica si el monto transferido es igual al saldo inicial del origen

---

### `main_notebook.ipynb`

Notebook principal desarrollado en Python.

Incluye:

- Carga del dataset
- Limpieza y validación de datos
- Análisis exploratorio de datos
- Análisis del desbalance de clases
- Ingeniería de variables
- Matriz de correlación
- Separación de datos en entrenamiento y prueba
- Entrenamiento de modelos de Machine Learning
- Evaluación de resultados
- Conclusiones

---

## Tecnologías utilizadas

- **Python**
- **Pandas**
- **NumPy**
- **Matplotlib**
- **Seaborn**
- **Scikit-learn**
- **MySQL**
- **Jupyter Notebook**

---

## Flujo de trabajo del análisis

### 1. Limpieza y validación de datos

En esta etapa se revisó la calidad inicial del dataset.

Se verificó que:

- No existieran valores nulos
- No existieran filas duplicadas
- No hubiera valores negativos en columnas monetarias
- Los tipos de transacción estuvieran correctamente registrados
- La suma de transacciones por tipo coincidiera con el total de filas

Resultados principales:

```text
Total de filas: 6,362,620
Valores nulos: 0
Duplicados: 0
```

---

### 2. Análisis exploratorio de datos

Se analizó la distribución de los tipos de transacción.

Tipos de transacción encontrados:

```text
CASH_IN:   1,399,284
CASH_OUT:  2,237,500
DEBIT:        41,432
PAYMENT:   2,151,495
TRANSFER:    532,909
```

También se encontró un fuerte desbalance en la variable objetivo:

```text
No fraude: 99.87%
Fraude:     0.13%
```

Esto confirma que el problema es un caso de **clasificación altamente desbalanceada**, algo común en problemas de detección de fraude.

---

### 3. Fraude por tipo de transacción

Al agrupar por tipo de transacción, se observó que los fraudes se concentran únicamente en:

```text
CASH_OUT:  4,116 fraudes
TRANSFER:  4,097 fraudes
```

No se encontraron fraudes en:

```text
CASH_IN
DEBIT
PAYMENT
```

Este hallazgo es importante porque indica que el tipo de transacción puede aportar información relevante al modelo.

---

### 4. Análisis de montos

Se comparó el promedio y la mediana del monto de las transacciones:

```text
Promedio de amount: 179,861.90
Mediana de amount:   74,871.94
```

La diferencia entre promedio y mediana sugiere la presencia de valores extremos u outliers, ya que algunas transacciones con montos muy altos elevan el promedio.

Además, se crearon dos variables:

- `monto_mayor_promedio`
- `monto_mayor_mediana`

Estas variables permiten identificar si una transacción tiene un monto superior al promedio o a la mediana.

---

## Ingeniería de variables

Para preparar los datos para Machine Learning, se crearon nuevas variables a partir de la información existente.

### Codificación de variables categóricas

La columna `type` fue transformada mediante One Hot Encoding manual.

Se crearon las siguientes columnas binarias:

```text
type_TRANSFER
type_PAYMENT
type_CASH_OUT
type_CASH_IN
type_DEBIT
```

Esto permite que los modelos puedan utilizar el tipo de transacción como variable numérica.

---

### Variables derivadas de saldos

También se crearon variables para representar cambios y posibles inconsistencias en los saldos:

| Variable | Descripción |
|---|---|
| `origin_balance_change` | Diferencia entre saldo inicial y saldo final de la cuenta origen |
| `dest_balance_change` | Diferencia entre saldo final y saldo inicial del destinatario |
| `orig_error` | Diferencia entre el monto y el cambio real en la cuenta origen |
| `dest_error` | Diferencia entre el monto y el cambio real en la cuenta destino |
| `orig_vacio` | Indica si la cuenta origen quedó en cero |
| `dest_vacio` | Indica si el destinatario tenía saldo inicial igual a cero |

Estas variables ayudaron a identificar patrones asociados a fraudes, especialmente aquellos donde la cuenta origen se vacía completamente.

---

## Matriz de correlación

Se calculó una matriz de correlación para identificar las variables más relacionadas con `isFraud`.

En lugar de graficar todas las variables, se seleccionaron las variables con mayor correlación absoluta con la variable objetivo, lo cual facilita la interpretación y evita una matriz demasiado saturada.

---

## Modelado de Machine Learning

El problema se abordó como una tarea de clasificación binaria:

```text
0 = Transacción no fraudulenta
1 = Transacción fraudulenta
```

Antes de entrenar los modelos, se eliminaron las columnas identificadoras:

```text
nameOrig
nameDest
```

Estas columnas no se utilizaron directamente en el modelo porque son identificadores únicos o casi únicos y pueden generar ruido o sobreajuste.

---

## División de datos

El dataset se dividió en entrenamiento y prueba usando una proporción 80/20:

```python
train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42,
    stratify=y
)
```

Se utilizó `stratify=y` para mantener la misma proporción de fraudes y no fraudes tanto en entrenamiento como en prueba.

---

## Modelos entrenados

Se entrenaron dos modelos principales:

1. **Random Forest**
2. **Regresión Logística**

---

## Primer modelo: Random Forest con todas las variables

Inicialmente se entrenó un modelo Random Forest utilizando todas las variables creadas.

El resultado fue prácticamente perfecto:

```text
precision    recall  f1-score
1.00         1.00    1.00
```

Sin embargo, este resultado sugirió la presencia de **fuga de información** (*data leakage*), ya que algunas variables derivadas de los saldos podían revelar directamente el fraude.

---

## Corrección por fuga de información

Para obtener una evaluación más realista, se eliminaron variables con riesgo de leakage:

```python
cols_eliminar = [
    "orig_error",
    "dest_error",
    "orig_vacio",
    "dest_vacio"
]
```

Después de eliminar estas variables, se volvió a entrenar el modelo.

---

## Random Forest balanceado

Se entrenó un nuevo modelo Random Forest utilizando:

```python
class_weight="balanced"
```

Resultados para la clase fraude:

```text
precision: 0.10
recall:    0.99
f1-score:  0.18
```

Interpretación:

- El modelo detecta casi todos los fraudes.
- El recall de 99% es muy alto.
- La precisión de 10% indica que todavía genera muchos falsos positivos.
- Es útil en contextos donde es más importante detectar fraudes que reducir alertas incorrectas.

---

## Regresión Logística balanceada

También se entrenó una Regresión Logística con escalamiento de variables mediante `StandardScaler`.

Resultados para la clase fraude:

```text
precision: 0.03
recall:    0.98
f1-score:  0.05
```

Interpretación:

- Detecta la mayoría de los fraudes.
- Tiene menor precisión que Random Forest.
- Genera más falsos positivos.
- Sirve como modelo base interpretable, pero no supera al Random Forest.

---

## Comparación de modelos

| Modelo | Precision fraude | Recall fraude | F1-score fraude | Comentario |
|---|---:|---:|---:|---|
| Random Forest balanceado | 0.10 | 0.99 | 0.18 | Mejor desempeño general |
| Regresión Logística balanceada | 0.03 | 0.98 | 0.05 | Modelo interpretable, pero con más falsos positivos |

El mejor modelo hasta esta etapa fue **Random Forest balanceado**, ya que logró un mejor equilibrio entre detección de fraudes y reducción de falsos positivos.

---

## Conclusiones

Este proyecto permitió desarrollar un flujo completo de análisis de fraude financiero utilizando SQL, Python y Machine Learning.

Los principales hallazgos fueron:

- El dataset no contiene valores nulos ni duplicados.
- La variable objetivo está fuertemente desbalanceada.
- Los fraudes representan aproximadamente el 0.13% de las transacciones.
- Los fraudes se concentran en transacciones de tipo `TRANSFER` y `CASH_OUT`.
- Las transacciones fraudulentas suelen estar relacionadas con patrones de vaciado de cuenta.
- El modelo inicial mostró resultados perfectos, lo que permitió identificar una posible fuga de información.
- Tras eliminar variables con riesgo de leakage, los resultados fueron más realistas.
- Random Forest balanceado obtuvo mejor desempeño que Regresión Logística.

---

## Limitaciones del proyecto

Algunas limitaciones actuales son:

- El dataset está altamente desbalanceado.
- La precisión del modelo para la clase fraude aún es baja.
- El modelo genera una cantidad considerable de falsos positivos.
- Algunas variables creadas pueden introducir fuga de información si no se usan con cuidado.
- No se realizó todavía una optimización profunda de hiperparámetros.

---

## Trabajo futuro

Como siguientes pasos, se propone:

- Aplicar técnicas de balanceo como **SMOTE** o **Random Under Sampling**
- Ajustar el umbral de clasificación para mejorar el equilibrio entre precisión y recall
- Optimizar hiperparámetros con `GridSearchCV` o `RandomizedSearchCV`
- Evaluar modelos adicionales como XGBoost, LightGBM o CatBoost
- Usar métricas adicionales como matriz de confusión, curva ROC-AUC y Precision-Recall AUC
- Analizar falsos positivos y falsos negativos
- Crear un dashboard en Power BI para comunicar los resultados
- Guardar el mejor modelo entrenado para uso posterior

---

## Métricas recomendadas para este problema

Debido al fuerte desbalance de clases, la accuracy no es suficiente para evaluar el modelo.

Las métricas más importantes son:

| Métrica | Importancia |
|---|---|
| Recall | Mide qué porcentaje de fraudes reales detecta el modelo |
| Precision | Mide qué porcentaje de alertas de fraude realmente son fraude |
| F1-score | Balance entre precision y recall |
| Matriz de confusión | Permite analizar falsos positivos y falsos negativos |
| PR-AUC | Útil en datasets altamente desbalanceados |

En este tipo de problema, el **recall** suele ser especialmente importante porque dejar pasar una transacción fraudulenta puede ser más costoso que generar una alerta falsa.

---

## Autor

Proyecto desarrollado por **Luis Eduardo** como parte de un portafolio de análisis de datos y Machine Learning aplicado a fraude financiero.

---

## Estado del proyecto

Proyecto en desarrollo.

Etapas completadas:

- [x] Carga de datos en SQL
- [x] Validación inicial de calidad de datos
- [x] Análisis exploratorio con SQL
- [x] Creación de vistas SQL
- [x] Análisis exploratorio con Python
- [x] Ingeniería de variables
- [x] Entrenamiento de modelos iniciales
- [x] Evaluación de Random Forest y Regresión Logística
- [x] Identificación de fuga de información
- [ ] Aplicación de técnicas de balanceo adicionales
- [ ] Optimización de hiperparámetros
- [ ] Dashboard en Power BI
- [ ] Despliegue o guardado del modelo

---

## Nota

Este proyecto tiene fines educativos y de portafolio. El dataset utilizado es sintético, por lo que los resultados no deben interpretarse como un sistema de detección de fraude listo para producción.
