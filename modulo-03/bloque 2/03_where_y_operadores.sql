/*
=====================================================================
MÓDULO 3 · BLOQUE 2
ARCHIVO: 03_where_y_operadores.sql
OBJETIVO: Aplicar condiciones con WHERE y operadores de comparación.
TABLAS: mimiciv_hosp.patients, mimiciv_hosp.admissions
TIPO DE OPERACIÓN: solo lectura.
=====================================================================
*/

-- Pacientes con anchor_age mayor o igual a 65.

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
WHERE anchor_age >= 65;

-- Pacientes con anchor_age mayor a 80.

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
WHERE anchor_age > 80;

-- Internaciones con admission_type igual a URGENT.

SELECT
    subject_id,
    hadm_id,
    admission_type
FROM mimiciv_hosp.admissions
WHERE admission_type = 'URGENT';

/*
OPERADORES

=   Igual a
>   Mayor que
<   Menor que
>=  Mayor o igual que
<=  Menor o igual que
<>  Distinto de

WHERE determina qué filas forman parte del resultado.
No elimina registros de la tabla original.
Los valores de texto se escriben entre comillas simples.
Cero filas no significa necesariamente que la consulta sea incorrecta.
*/
