/*
Curso de Posgrado: Bases de Datos Abiertas en Salud
Módulo 4: SQL II — JOIN y agregaciones

Archivo:
00_verificacion_entorno.sql

Objetivo:
Comprobar que las tablas utilizadas durante el módulo
están disponibles en la base de datos seleccionada.
*/

SELECT
    COUNT(*) AS cantidad_pacientes
FROM mimiciv_hosp.patients;

SELECT
    COUNT(*) AS cantidad_hospitalizaciones
FROM mimiciv_hosp.admissions;

SELECT
    COUNT(*) AS cantidad_estancias_uci
FROM mimiciv_icu.icustays;

SELECT
    COUNT(*) AS cantidad_diagnosticos
FROM mimiciv_hosp.diagnoses_icd;