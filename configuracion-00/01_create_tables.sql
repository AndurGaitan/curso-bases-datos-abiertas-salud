-- ============================================================
-- CURSO: BASES DE DATOS ABIERTAS EN SALUD
-- MIMIC-IV Demo v2.2 - Preparacion del Entorno de Datos
-- Script 01: Crear esquemas y tablas seleccionadas
-- Ejecucion: pgAdmin -> Query Tool conectado a la base mimiciv_demo
-- ============================================================

-- ADVERTENCIA:
-- Este script elimina y vuelve a crear los esquemas mimiciv_hosp,
-- mimiciv_icu y mimiciv_derived. Si existen datos previos, se perderan.

DROP SCHEMA IF EXISTS mimiciv_hosp CASCADE;
CREATE SCHEMA mimiciv_hosp;

DROP SCHEMA IF EXISTS mimiciv_icu CASCADE;
CREATE SCHEMA mimiciv_icu;

DROP SCHEMA IF EXISTS mimiciv_derived CASCADE;
CREATE SCHEMA mimiciv_derived;

-- ============================================================
-- ESQUEMA HOSP
-- ============================================================

CREATE TABLE mimiciv_hosp.patients (
    subject_id INTEGER NOT NULL,
    gender CHAR(1) NOT NULL,
    anchor_age SMALLINT,
    anchor_year SMALLINT NOT NULL,
    anchor_year_group VARCHAR(20) NOT NULL,
    dod DATE
);

CREATE TABLE mimiciv_hosp.admissions (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    admittime TIMESTAMP NOT NULL,
    dischtime TIMESTAMP,
    deathtime TIMESTAMP,
    admission_type VARCHAR(40) NOT NULL,
    admit_provider_id VARCHAR(10),
    admission_location VARCHAR(60),
    discharge_location VARCHAR(60),
    insurance VARCHAR(255),
    language VARCHAR(25),
    marital_status VARCHAR(30),
    race VARCHAR(80),
    edregtime TIMESTAMP,
    edouttime TIMESTAMP,
    hospital_expire_flag SMALLINT
);

CREATE TABLE mimiciv_hosp.labevents (
    labevent_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER,
    specimen_id INTEGER NOT NULL,
    itemid INTEGER NOT NULL,
    order_provider_id VARCHAR(10),
    charttime TIMESTAMP(0),
    storetime TIMESTAMP(0),
    value VARCHAR(200),
    valuenum DOUBLE PRECISION,
    valueuom VARCHAR(20),
    ref_range_lower DOUBLE PRECISION,
    ref_range_upper DOUBLE PRECISION,
    flag VARCHAR(10),
    priority VARCHAR(7),
    comments TEXT
);

CREATE TABLE mimiciv_hosp.d_labitems (
    itemid INTEGER NOT NULL,
    label VARCHAR(50),
    fluid VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE mimiciv_hosp.diagnoses_icd (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    seq_num INTEGER NOT NULL,
    icd_code CHAR(7),
    icd_version SMALLINT
);

CREATE TABLE mimiciv_hosp.d_icd_diagnoses (
    icd_code CHAR(7) NOT NULL,
    icd_version SMALLINT NOT NULL,
    long_title VARCHAR(255)
);

CREATE TABLE mimiciv_hosp.prescriptions (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    pharmacy_id INTEGER NOT NULL,
    poe_id VARCHAR(25),
    poe_seq INTEGER,
    order_provider_id VARCHAR(10),
    starttime TIMESTAMP(3),
    stoptime TIMESTAMP(3),
    drug_type VARCHAR(20) NOT NULL,
    drug VARCHAR(255) NOT NULL,
    formulary_drug_cd VARCHAR(50),
    gsn VARCHAR(255),
    ndc VARCHAR(25),
    prod_strength VARCHAR(255),
    form_rx VARCHAR(25),
    dose_val_rx VARCHAR(100),
    dose_unit_rx VARCHAR(50),
    form_val_disp VARCHAR(50),
    form_unit_disp VARCHAR(50),
    doses_per_24_hrs REAL,
    route VARCHAR(50)
);

-- ============================================================
-- ESQUEMA ICU
-- ============================================================

CREATE TABLE mimiciv_icu.icustays (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    stay_id INTEGER NOT NULL,
    first_careunit VARCHAR(255),
    last_careunit VARCHAR(255),
    intime TIMESTAMP,
    outtime TIMESTAMP,
    los FLOAT
);

-- ============================================================
-- INDICES DIDACTICOS BASICOS
-- Se crean despues de las tablas para mejorar consultas frecuentes.
-- No se aplican constraints en esta etapa para evitar fallas de carga.
-- ============================================================

CREATE INDEX idx_patients_subject_id ON mimiciv_hosp.patients (subject_id);
CREATE INDEX idx_admissions_subject_id ON mimiciv_hosp.admissions (subject_id);
CREATE INDEX idx_admissions_hadm_id ON mimiciv_hosp.admissions (hadm_id);
CREATE INDEX idx_icustays_subject_id ON mimiciv_icu.icustays (subject_id);
CREATE INDEX idx_icustays_hadm_id ON mimiciv_icu.icustays (hadm_id);
CREATE INDEX idx_icustays_stay_id ON mimiciv_icu.icustays (stay_id);
CREATE INDEX idx_labevents_subject_id ON mimiciv_hosp.labevents (subject_id);
CREATE INDEX idx_labevents_hadm_id ON mimiciv_hosp.labevents (hadm_id);
CREATE INDEX idx_labevents_itemid ON mimiciv_hosp.labevents (itemid);
CREATE INDEX idx_d_labitems_itemid ON mimiciv_hosp.d_labitems (itemid);
CREATE INDEX idx_diagnoses_hadm_id ON mimiciv_hosp.diagnoses_icd (hadm_id);
CREATE INDEX idx_diagnoses_icd_code ON mimiciv_hosp.diagnoses_icd (icd_code, icd_version);
CREATE INDEX idx_d_icd_diagnoses_code ON mimiciv_hosp.d_icd_diagnoses (icd_code, icd_version);
CREATE INDEX idx_prescriptions_hadm_id ON mimiciv_hosp.prescriptions (hadm_id);

-- Verificacion rapida de tablas creadas
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema IN ('mimiciv_hosp', 'mimiciv_icu')
ORDER BY table_schema, table_name;
