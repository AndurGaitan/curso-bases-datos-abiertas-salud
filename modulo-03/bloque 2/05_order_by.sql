/*
=====================================================================
MÓDULO 3 · BLOQUE 2
ARCHIVO: 05_order_by.sql
OBJETIVO: Organizar resultados con ORDER BY.
TABLAS: mimiciv_hosp.patients, mimiciv_icu.icustays
TIPO DE OPERACIÓN: solo lectura.
=====================================================================
*/

-- Orden ascendente por anchor_age.

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
ORDER BY anchor_age ASC;

-- Orden descendente por anchor_age.

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
ORDER BY anchor_age DESC;

-- Diez estancias ordenadas por los, de mayor a menor.

SELECT
    subject_id,
    hadm_id,
    stay_id,
    los
FROM mimiciv_icu.icustays
ORDER BY los DESC
LIMIT 10;

/*
INTERPRETACIÓN

ORDER BY organiza la presentación de las filas.
No modifica la tabla ni define por sí mismo una población nueva.
ASC indica orden ascendente.
DESC indica orden descendente.
*/
