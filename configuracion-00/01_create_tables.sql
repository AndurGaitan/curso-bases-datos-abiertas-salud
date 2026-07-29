-- ============================================================
-- CURSO: BASES DE DATOS ABIERTAS EN SALUD
-- MIMIC-IV Demo v2.2 - Preparación del Entorno de Datos
-- Script 01: Crear esquemas y tablas necesarias para el curso
-- Base sugerida: mimiciv_demo_v1
-- Ejecución: pgAdmin -> Query Tool conectado a mimiciv_demo_v1
-- ============================================================
--
-- ADVERTENCIA:
-- Este script elimina y vuelve a crear los esquemas:
--     mimiciv_hosp
--     mimiciv_icu
--     mimiciv_derived
--
-- Si existen datos previos, se perderán.
--
-- OBJETIVO:
-- Crear las tablas base necesarias para cargar los CSV de MIMIC-IV Demo
-- y ejecutar posteriormente el pipeline docente de cohorte de sepsis:
--
--     hemocultivo + antibiótico
--     +
--     delta SOFA demo >= 2
--
-- TABLA FINAL DEL PIPELINE:
--     mimiciv_derived.sepsis_blood_culture_delta_sofa_demo
-- ============================================================


-- ============================================================
-- 0. CREACIÓN DE ESQUEMAS
-- ============================================================

DROP SCHEMA IF EXISTS mimiciv_hosp CASCADE;
CREATE SCHEMA mimiciv_hosp;

DROP SCHEMA IF EXISTS mimiciv_icu CASCADE;
CREATE SCHEMA mimiciv_icu;

DROP SCHEMA IF EXISTS mimiciv_derived CASCADE;
CREATE SCHEMA mimiciv_derived;


-- ============================================================
-- 1. ESQUEMA HOSP
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Pacientes
-- ------------------------------------------------------------

CREATE TABLE mimiciv_hosp.patients (
    subject_id INTEGER NOT NULL,
    gender CHAR(1) NOT NULL,
    anchor_age SMALLINT,
    anchor_year SMALLINT NOT NULL,
    anchor_year_group VARCHAR(20) NOT NULL,
    dod DATE
);


-- ------------------------------------------------------------
-- 1.2 Internaciones hospitalarias
-- ------------------------------------------------------------

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


-- ------------------------------------------------------------
-- 1.3 Prescripciones
-- Uso en el pipeline:
--     Identificación de antibióticos.
-- ------------------------------------------------------------

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


-- ------------------------------------------------------------
-- 1.4 Eventos de microbiología
-- Uso en el pipeline:
--     Identificación de hemocultivos.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_hosp.microbiologyevents (
    microevent_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER,
    micro_specimen_id INTEGER NOT NULL,
    order_provider_id VARCHAR(10),
    chartdate DATE NOT NULL,
    charttime TIMESTAMP,
    spec_itemid INTEGER NOT NULL,
    spec_type_desc VARCHAR(100) NOT NULL,
    test_seq INTEGER NOT NULL,
    storedate DATE,
    storetime TIMESTAMP,
    test_itemid INTEGER,
    test_name VARCHAR(100),
    org_itemid INTEGER,
    org_name VARCHAR(100),
    isolate_num SMALLINT,
    quantity VARCHAR(50),
    ab_itemid INTEGER,
    ab_name VARCHAR(30),
    dilution_text VARCHAR(10),
    dilution_comparison VARCHAR(20),
    dilution_value DOUBLE PRECISION,
    interpretation VARCHAR(5),
    comments TEXT
);


-- ------------------------------------------------------------
-- 1.5 Laboratorios
-- Uso en el pipeline:
--     Creatinina, plaquetas, bilirrubina total y PaO2.
-- ------------------------------------------------------------

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


-- ------------------------------------------------------------
-- 1.6 Diccionario de laboratorios
-- Uso en el pipeline:
--     Interpretar itemid de labevents.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_hosp.d_labitems (
    itemid INTEGER NOT NULL,
    label VARCHAR(50),
    fluid VARCHAR(50),
    category VARCHAR(50)
);


-- ------------------------------------------------------------
-- 1.7 Diagnósticos ICD
-- Uso:
--     Opcional para auditorías o ejercicios posteriores.
--     No es obligatorio para la cohorte principal de sepsis.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_hosp.diagnoses_icd (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    seq_num INTEGER NOT NULL,
    icd_code CHAR(7),
    icd_version SMALLINT
);


-- ------------------------------------------------------------
-- 1.8 Diccionario de diagnósticos ICD
-- Uso:
--     Opcional para interpretar diagnoses_icd.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_hosp.d_icd_diagnoses (
    icd_code CHAR(7) NOT NULL,
    icd_version SMALLINT NOT NULL,
    long_title VARCHAR(255)
);


-- ============================================================
-- 2. ESQUEMA ICU
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 Estancias UCI
-- Uso en el pipeline:
--     Relacionar internaciones hospitalarias con estancias críticas.
-- ------------------------------------------------------------

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


-- ------------------------------------------------------------
-- 2.2 Diccionario de eventos de UCI
-- Uso en el pipeline:
--     Interpretar itemid de chartevents, inputevents y outputevents.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_icu.d_items (
    itemid INTEGER NOT NULL,
    label VARCHAR(200) NOT NULL,
    abbreviation VARCHAR(100),
    linksto VARCHAR(50) NOT NULL,
    category VARCHAR(100) NOT NULL,
    unitname VARCHAR(100),
    param_type VARCHAR(30) NOT NULL,
    lownormalvalue DOUBLE PRECISION,
    highnormalvalue DOUBLE PRECISION
);


-- ------------------------------------------------------------
-- 2.3 Eventos registrados en la hoja clínica de UCI
-- Uso en el pipeline:
--     MAP, GCS, FiO2, soporte ventilatorio.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_icu.chartevents (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    stay_id INTEGER NOT NULL,
    caregiver_id INTEGER,
    charttime TIMESTAMP NOT NULL,
    storetime TIMESTAMP,
    itemid INTEGER NOT NULL,
    value VARCHAR(200),
    valuenum DOUBLE PRECISION,
    valueuom VARCHAR(20),
    warning SMALLINT
);


-- ------------------------------------------------------------
-- 2.4 Eventos de entrada
-- Uso en el pipeline:
--     Vasopresores e inotrópicos.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_icu.inputevents (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    stay_id INTEGER NOT NULL,
    caregiver_id INTEGER,
    starttime TIMESTAMP NOT NULL,
    endtime TIMESTAMP NOT NULL,
    storetime TIMESTAMP NOT NULL,
    itemid INTEGER NOT NULL,
    amount DOUBLE PRECISION,
    amountuom VARCHAR(30),
    rate DOUBLE PRECISION,
    rateuom VARCHAR(30),
    orderid INTEGER NOT NULL,
    linkorderid INTEGER,
    ordercategoryname VARCHAR(100),
    secondaryordercategoryname VARCHAR(100),
    ordercomponenttypedescription VARCHAR(200),
    ordercategorydescription VARCHAR(50),
    patientweight DOUBLE PRECISION,
    totalamount DOUBLE PRECISION,
    totalamountuom VARCHAR(50),
    isopenbag SMALLINT,
    continueinnextdept SMALLINT,
    statusdescription VARCHAR(30),
    originalamount DOUBLE PRECISION,
    originalrate DOUBLE PRECISION
);


-- ------------------------------------------------------------
-- 2.5 Eventos de salida
-- Uso en el pipeline:
--     Diuresis.
-- ------------------------------------------------------------

CREATE TABLE mimiciv_icu.outputevents (
    subject_id INTEGER NOT NULL,
    hadm_id INTEGER NOT NULL,
    stay_id INTEGER NOT NULL,
    caregiver_id INTEGER,
    charttime TIMESTAMP NOT NULL,
    storetime TIMESTAMP NOT NULL,
    itemid INTEGER NOT NULL,
    value DOUBLE PRECISION NOT NULL,
    valueuom VARCHAR(30)
);


-- ============================================================
-- 3. ÍNDICES DIDÁCTICOS BÁSICOS
-- ============================================================
--
-- Se crean después de las tablas para mejorar consultas frecuentes.
-- No se aplican claves primarias ni foráneas en esta etapa para evitar
-- fallas de carga durante la importación inicial de CSV.
-- ============================================================

-- HOSP
CREATE INDEX idx_patients_subject_id
ON mimiciv_hosp.patients (subject_id);

CREATE INDEX idx_admissions_subject_id
ON mimiciv_hosp.admissions (subject_id);

CREATE INDEX idx_admissions_hadm_id
ON mimiciv_hosp.admissions (hadm_id);

CREATE INDEX idx_prescriptions_subject_id
ON mimiciv_hosp.prescriptions (subject_id);

CREATE INDEX idx_prescriptions_hadm_id
ON mimiciv_hosp.prescriptions (hadm_id);

CREATE INDEX idx_prescriptions_starttime
ON mimiciv_hosp.prescriptions (starttime);

CREATE INDEX idx_microbiologyevents_subject_id
ON mimiciv_hosp.microbiologyevents (subject_id);

CREATE INDEX idx_microbiologyevents_hadm_id
ON mimiciv_hosp.microbiologyevents (hadm_id);

CREATE INDEX idx_microbiologyevents_charttime
ON mimiciv_hosp.microbiologyevents (charttime);

CREATE INDEX idx_microbiologyevents_spec_type_desc
ON mimiciv_hosp.microbiologyevents (spec_type_desc);

CREATE INDEX idx_labevents_subject_id
ON mimiciv_hosp.labevents (subject_id);

CREATE INDEX idx_labevents_hadm_id
ON mimiciv_hosp.labevents (hadm_id);

CREATE INDEX idx_labevents_itemid
ON mimiciv_hosp.labevents (itemid);

CREATE INDEX idx_labevents_charttime
ON mimiciv_hosp.labevents (charttime);

CREATE INDEX idx_d_labitems_itemid
ON mimiciv_hosp.d_labitems (itemid);

CREATE INDEX idx_diagnoses_hadm_id
ON mimiciv_hosp.diagnoses_icd (hadm_id);

CREATE INDEX idx_diagnoses_icd_code
ON mimiciv_hosp.diagnoses_icd (icd_code, icd_version);

CREATE INDEX idx_d_icd_diagnoses_code
ON mimiciv_hosp.d_icd_diagnoses (icd_code, icd_version);


-- ICU
CREATE INDEX idx_icustays_subject_id
ON mimiciv_icu.icustays (subject_id);

CREATE INDEX idx_icustays_hadm_id
ON mimiciv_icu.icustays (hadm_id);

CREATE INDEX idx_icustays_stay_id
ON mimiciv_icu.icustays (stay_id);

CREATE INDEX idx_icustays_intime
ON mimiciv_icu.icustays (intime);

CREATE INDEX idx_d_items_itemid
ON mimiciv_icu.d_items (itemid);

CREATE INDEX idx_chartevents_subject_id
ON mimiciv_icu.chartevents (subject_id);

CREATE INDEX idx_chartevents_hadm_id
ON mimiciv_icu.chartevents (hadm_id);

CREATE INDEX idx_chartevents_stay_id
ON mimiciv_icu.chartevents (stay_id);

CREATE INDEX idx_chartevents_itemid
ON mimiciv_icu.chartevents (itemid);

CREATE INDEX idx_chartevents_charttime
ON mimiciv_icu.chartevents (charttime);

CREATE INDEX idx_inputevents_subject_id
ON mimiciv_icu.inputevents (subject_id);

CREATE INDEX idx_inputevents_hadm_id
ON mimiciv_icu.inputevents (hadm_id);

CREATE INDEX idx_inputevents_stay_id
ON mimiciv_icu.inputevents (stay_id);

CREATE INDEX idx_inputevents_itemid
ON mimiciv_icu.inputevents (itemid);

CREATE INDEX idx_inputevents_starttime
ON mimiciv_icu.inputevents (starttime);

CREATE INDEX idx_outputevents_subject_id
ON mimiciv_icu.outputevents (subject_id);

CREATE INDEX idx_outputevents_hadm_id
ON mimiciv_icu.outputevents (hadm_id);

CREATE INDEX idx_outputevents_stay_id
ON mimiciv_icu.outputevents (stay_id);

CREATE INDEX idx_outputevents_itemid
ON mimiciv_icu.outputevents (itemid);

CREATE INDEX idx_outputevents_charttime
ON mimiciv_icu.outputevents (charttime);


-- ============================================================
-- 4. VERIFICACIÓN RÁPIDA DE TABLAS CREADAS
-- ============================================================

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema IN ('mimiciv_hosp', 'mimiciv_icu', 'mimiciv_derived')
ORDER BY table_schema, table_name;