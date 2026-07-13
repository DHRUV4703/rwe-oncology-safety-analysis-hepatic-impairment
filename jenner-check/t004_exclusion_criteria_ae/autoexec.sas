options obs=100;   /* cap input rows for the captured run */

/* --------------------------------------------------------------------------
   The exclusion step reads L0.Diagnosis (the Flatiron EHR diagnosis table,
   not distributed with the repo) and joins ic3_hepatic, the hepatic-eligible
   cohort carried forward from IC3 (here it carries the per-patient index_date
   the script reads as c.index_date). We seed a small stand-in for L0.Diagnosis
   and a small ic3_hepatic so the script's real logic runs unchanged: the
   ICD-10-CM 30-day pre-index diagnosis window (INTCK), the AE-code range
   predicates, and the NOT IN subquery that drops patients with a prior AE.
   The script reads WORK.Diagnosis instead of L0.Diagnosis.

   Mock data is constructed to hit each branch:
     P0001 - febrile-neutropenia code (D70.1) 10 days pre-index  -> excluded
     P0002 - nausea code (R11.0) 5 days pre-index                -> excluded
     P0005 - unrelated code (I10) 15 days pre-index              -> kept
     P0007 - AE code but 60 days pre-index (outside 30d window)  -> kept
   -------------------------------------------------------------------------- */

data ic3_hepatic;
    length patientid $8;
    input patientid $ index_date :date9.;
    format index_date date9.;
    datalines;
P0001 01JUL2021
P0002 20SEP2022
P0005 12FEB2023
P0007 12FEB2023
;
run;

data Diagnosis;
    length patientid $8 diagnosiscode $10 diagnosiscodesystem $12;
    input patientid $ diagnosisdate :date9. diagnosiscode $ diagnosiscodesystem & $12.;
    format diagnosisdate date9.;
    datalines;
P0001 21JUN2021 D70.1 ICD-10-CM
P0002 15SEP2022 R11.0 ICD-10-CM
P0005 28JAN2023 I10 ICD-10-CM
P0007 14DEC2022 R50.9 ICD-10-CM
;
run;
