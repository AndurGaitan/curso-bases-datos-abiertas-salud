/*
=====================================================================
MÓDULO 3 · BLOQUE 1
ARCHIVO: 01_select_from.sql
OBJETIVO: Ejecutar una primera consulta con SELECT y FROM.
TABLA: mimiciv_hosp.patients
UNIDAD DE ANÁLISIS: una fila representa un paciente.
TIPO DE OPERACIÓN: solo lectura.
=====================================================================
*/

-- Pregunta: ¿Qué información contiene la tabla patients?

SELECT *
FROM mimiciv_hosp.patients;

/*
INTERPRETACIÓN

SELECT indica qué información queremos recuperar.
El asterisco (*) representa todas las columnas disponibles.
FROM indica la tabla de origen.

PostgreSQL devuelve un resultado organizado en filas y columnas.
La consulta no modifica la tabla almacenada.

ACTIVIDAD

1. Ejecute la consulta.
2. Identifique subject_id, gender y anchor_age.
3. Observe la estructura sin interpretar todavía todas las variables.
*/
