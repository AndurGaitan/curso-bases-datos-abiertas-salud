/*
=====================================================================
MÓDULO 3 · BLOQUE 1
ARCHIVO: 02_columnas_y_limit.sql
OBJETIVO: Seleccionar columnas y utilizar LIMIT para explorar.
TABLA: mimiciv_hosp.patients
UNIDAD DE ANÁLISIS: una fila representa un paciente.
TIPO DE OPERACIÓN: solo lectura.
=====================================================================
*/

-- Pregunta: ¿Qué identificador, sexo y edad están registrados?

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients;

-- Pregunta: ¿Cómo observar una cantidad pequeña de filas?

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
LIMIT 10;

/*
INTERPRETACIÓN

Seleccionar columnas específicas hace explícitas las variables que
forman parte de la consulta.

LIMIT establece la cantidad máxima de filas mostradas.
No elimina registros ni modifica la tabla.
Sin ORDER BY, LIMIT no establece un orden controlado.

ACTIVIDAD

1. Cambie LIMIT 10 por LIMIT 5.
2. Ejecute la consulta.
*/