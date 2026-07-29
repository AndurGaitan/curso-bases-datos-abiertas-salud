/*
=====================================================================
CURSO DE POSGRADO · BASES DE DATOS ABIERTAS EN SALUD
MÓDULO 3 · SQL I: SELECCIÓN Y FILTROS
ARCHIVO: 00_verificar_entorno.sql
=====================================================================

OBJETIVO:
Comprobar que el Query Tool está conectado a la base correcta y que
las tablas utilizadas en el módulo están disponibles.

TIPO DE OPERACIÓN:
Solo lectura.
=====================================================================
*/

SELECT current_database();

SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name IN ('mimiciv_hosp', 'mimiciv_icu')
ORDER BY schema_name;

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE
    (table_schema = 'mimiciv_hosp'
     AND table_name IN ('patients', 'admissions'))
    OR
    (table_schema = 'mimiciv_icu'
     AND table_name = 'icustays')
ORDER BY
    table_schema,
    table_name;

/*
El módulo requiere:
- mimiciv_hosp.patients
- mimiciv_hosp.admissions
- mimiciv_icu.icustays

Si alguna tabla no aparece, revise la base activa, los esquemas creados
y el proceso de carga antes de modificar las consultas.
*/
