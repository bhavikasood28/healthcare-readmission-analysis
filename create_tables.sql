CREATE DATABASE hospital_readmission;
GO

USE hospital_readmission;
GO


CREATE TABLE admission_type_lookup (
    id INT PRIMARY KEY,
    admission_type_desc VARCHAR(100)
);


CREATE TABLE discharge_disposition_lookup (
    id INT PRIMARY KEY,
    discharge_disposition_desc VARCHAR(255)
);


CREATE TABLE admission_source_lookup (
    id INT PRIMARY KEY,
    admission_source_desc VARCHAR(255)
);


CREATE TABLE patient_encounters (
    encounter_id BIGINT PRIMARY KEY,
    patient_nbr BIGINT,
    race VARCHAR(50),
    gender VARCHAR(10),
    age VARCHAR(20),
    weight VARCHAR(20),

    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,

    time_in_hospital INT,
    payer_code VARCHAR(20),
    medical_specialty VARCHAR(100),

    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,

    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,

    diag_1 VARCHAR(20),
    diag_2 VARCHAR(20),
    diag_3 VARCHAR(20),

    number_diagnoses INT,
    max_glu_serum VARCHAR(20),
    a1cresult VARCHAR(20),

    metformin VARCHAR(10),
    repaglinide VARCHAR(10),
    nateglinide VARCHAR(10),
    chlorpropamide VARCHAR(10),
    glimepiride VARCHAR(10),
    acetohexamide VARCHAR(10),
    glipizide VARCHAR(10),
    glyburide VARCHAR(10),
    tolbutamide VARCHAR(10),
    pioglitazone VARCHAR(10),
    rosiglitazone VARCHAR(10),
    acarbose VARCHAR(10),
    miglitol VARCHAR(10),
    troglitazone VARCHAR(10),
    tolazamide VARCHAR(10),
    examide VARCHAR(10),
    citoglipton VARCHAR(10),
    insulin VARCHAR(20),
    glyburide_metformin VARCHAR(10),
    glipizide_metformin VARCHAR(10),
    glimepiride_pioglitazone VARCHAR(10),
    metformin_rosiglitazone VARCHAR(10),
    metformin_pioglitazone VARCHAR(10),

    change VARCHAR(10),
    diabetesmed VARCHAR(10),
    readmitted VARCHAR(10),

    admission_type_desc VARCHAR(100),
    discharge_disposition_desc VARCHAR(255),
    admission_source_desc VARCHAR(255)
);
