SELECT TOP 5 * 
FROM patient_encounters;


SELECT COUNT(*) FROM patient_encounters;


USE hospital_readmission;
GO

WITH ordered_encounters AS (
    SELECT 
        encounter_id,
        patient_nbr,
        admission_type_id,
        discharge_disposition_id,
        admission_source_id,
        time_in_hospital,
        readmitted,
        ROW_NUMBER() OVER (
            PARTITION BY patient_nbr
            ORDER BY encounter_id
        ) AS rn
    FROM patient_encounters
),

next_encounter AS (
    SELECT 
        e1.*,
        e2.encounter_id AS next_encounter_id,
        e2.readmitted AS next_readmitted
    FROM ordered_encounters e1
    LEFT JOIN ordered_encounters e2
        ON e1.patient_nbr = e2.patient_nbr
        AND e1.rn + 1 = e2.rn
)

SELECT TOP 20 *
FROM next_encounter
ORDER BY patient_nbr, rn;


USE hospital_readmission;
GO

WITH ordered_encounters AS (
    SELECT 
        encounter_id,
        patient_nbr,
        readmitted,
        ROW_NUMBER() OVER (
            PARTITION BY patient_nbr ORDER BY encounter_id
        ) AS rn
    FROM patient_encounters
),

next_visit AS (
    SELECT 
        e1.*,
        e2.readmitted AS next_readmitted
    FROM ordered_encounters e1
    LEFT JOIN ordered_encounters e2
        ON e1.patient_nbr = e2.patient_nbr
        AND e1.rn + 1 = e2.rn
),

readmission_logic AS (
    SELECT *,
           CASE 
               WHEN next_readmitted = '<30' THEN 1
               ELSE 0
           END AS readmit_30_flag
    FROM next_visit
)

SELECT TOP 20 *
FROM readmission_logic
ORDER BY patient_nbr, rn;


USE hospital_readmission;
GO

DROP TABLE IF EXISTS encounter_readmission_flag;

SELECT 
    encounter_id,
    patient_nbr,
    readmitted,
    next_readmitted,
    CASE 
        WHEN next_readmitted = '<30' THEN 1
        ELSE 0
    END AS readmit_30_flag
INTO encounter_readmission_flag
FROM (
    WITH ordered_encounters AS (
        SELECT 
            encounter_id,
            patient_nbr,
            readmitted,
            ROW_NUMBER() OVER (
                PARTITION BY patient_nbr ORDER BY encounter_id
            ) AS rn
        FROM patient_encounters
    ),
    next_visit AS (
        SELECT 
            e1.*,
            e2.readmitted AS next_readmitted
        FROM ordered_encounters e1
        LEFT JOIN ordered_encounters e2
            ON e1.patient_nbr = e2.patient_nbr
            AND e1.rn + 1 = e2.rn
    )
    SELECT *
    FROM next_visit
) t;


SELECT 
    diag_1,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN r.readmit_30_flag = 1 THEN 1 ELSE 0 END) AS readmissions_30,
    ROUND(100.0 * SUM(CASE WHEN r.readmit_30_flag = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) 
        AS readmission_rate_percent
FROM patient_encounters p
JOIN encounter_readmission_flag r
    ON p.encounter_id = r.encounter_id
GROUP BY diag_1
ORDER BY readmissions_30 DESC;


SELECT 
    age,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN r.readmit_30_flag = 1 THEN 1 ELSE 0 END) AS readmissions_30,
    ROUND(100.0 * SUM(CASE WHEN r.readmit_30_flag = 1 THEN 1 ELSE 0 END) / COUNT(*), 2)
        AS readmission_rate_percent
FROM patient_encounters p
JOIN encounter_readmission_flag r
    ON p.encounter_id = r.encounter_id
GROUP BY age
ORDER BY age;


SELECT 
    insulin,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN r.readmit_30_flag = 1 THEN 1 ELSE 0 END) AS readmissions_30,
    ROUND(100.0 * SUM(CASE WHEN r.readmit_30_flag = 1 THEN 1 ELSE 0 END) / COUNT(*), 2)
        AS readmission_rate_percent
FROM patient_encounters p
JOIN encounter_readmission_flag r
    ON p.encounter_id = r.encounter_id
GROUP BY insulin
ORDER BY readmission_rate_percent DESC;


