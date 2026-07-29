/*
=====================================================================
MÓDULO 3 · BLOQUE 2
ARCHIVO: 04_and_or.sql
OBJETIVO: Combinar condiciones mediante AND y OR.
TABLA: mimiciv_hosp.patients
UNIDAD DE ANÁLISIS: una fila representa un paciente.
TIPO DE OPERACIÓN: solo lectura.
=====================================================================
*/

-- AND: ambas condiciones deben cumplirse.

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
WHERE anchor_age >= 65
  AND gender = 'F';

-- OR: debe cumplirse al menos una condición.

SELECT
    subject_id,
    gender,
    anchor_age
FROM mimiciv_hosp.patients
WHERE anchor_age >= 65
   OR gender = 'F';

/*
ACTIVIDAD

1. Ejecute la consulta con AND.
2. Observe la cantidad de filas.
3. Ejecute la consulta con OR.
4. Compare los resultados.
5. Explique en lenguaje natural cómo cambió el criterio.
*/
