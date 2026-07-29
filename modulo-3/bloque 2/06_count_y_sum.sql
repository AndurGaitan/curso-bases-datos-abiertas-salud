/*
=====================================================================
MÓDULO 3 · BLOQUE 2
ARCHIVO: 06_count_y_sum.sql
OBJETIVO: Obtener resúmenes simples con COUNT() y SUM().
TABLAS: patients, admissions e icustays.
TIPO DE OPERACIÓN: solo lectura.
=====================================================================
*/

-- Cantidad de registros de patients.

SELECT
    COUNT(*)
FROM mimiciv_hosp.patients;

-- Cantidad de registros de admissions.

SELECT
    COUNT(*)
FROM mimiciv_hosp.admissions;

-- Cantidad de registros de icustays.

SELECT
    COUNT(*)
FROM mimiciv_icu.icustays;

-- Suma acumulada de los.

SELECT
    SUM(los)
FROM mimiciv_icu.icustays;

/*
UNIDAD DE ANÁLISIS

patients   -> una fila representa un paciente.
admissions -> una fila representa una internación hospitalaria.
icustays   -> una fila representa una estancia en UCI.

COUNT(*) cuenta filas. Su interpretación depende de la tabla.
SUM(los) no representa una estancia individual, un conteo ni un promedio.
*/
