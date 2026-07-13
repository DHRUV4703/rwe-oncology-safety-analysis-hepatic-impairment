options obs=100;   /* cap input rows for the captured run */

/* --------------------------------------------------------------------------
   The original script reads two tables from the L0 libname (the Flatiron EHR
   database, which is not distributed with the repo). To let the script's real
   PROC SQL logic run in isolation, we seed small stand-in tables with the same
   column shapes and types the script consumes, then point the script at WORK.
   The join, the metastatic/age filter, and the Age_At_Diagnosis expression are
   the author's, unchanged.
   -------------------------------------------------------------------------- */

data Demographics;
    length PatientID $8;
    input PatientID $ BirthYear;
    datalines;
P0001 1958
P0002 1975
P0003 1990
P0004 2005
P0005 1962
P0006 1948
P0007 1980
;
run;

data Extracted_BreastDiagnosis;
    length PatientID $8;
    input PatientID $ DiagnosisDate :date9. IsMetastatic;
    format DiagnosisDate date9.;
    datalines;
P0001 15MAR2021 1
P0002 02JUN2022 1
P0003 20JAN2023 0
P0004 10FEB2022 1
P0005 05MAY2020 1
P0006 30NOV2021 0
P0007 18JUL2023 1
;
run;
