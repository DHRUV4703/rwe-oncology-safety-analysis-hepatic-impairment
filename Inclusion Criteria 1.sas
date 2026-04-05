/*--- Step 1: Identify adult (≥18) metastatic breast cancer (mBC) patients ---*/

PROC SQL;

CREATE TABLE crit1_mbc AS
SELECT  
        d.PatientID,
        d.BirthYear,
        bd.DiagnosisDate,
        bd.IsMetastatic,
        /* Compute Age at Diagnosis */
        (YEAR(bd.DiagnosisDate) - d.BirthYear) AS Age_At_Diagnosis
FROM L0.Demographics d
INNER JOIN L0.Extracted_BreastDiagnosis bd
    ON d.PatientID = bd.PatientID
/* Use your actual metastatic flag: 1 = metastatic, 0 = non-metastatic */
WHERE bd.IsMetastatic = 1  
/* Age 18+ at metastatic diagnosis */
  AND (YEAR(bd.DiagnosisDate) - d.BirthYear) >= 18;
QUIT;
