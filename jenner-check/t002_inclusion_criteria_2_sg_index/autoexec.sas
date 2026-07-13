options obs=100;   /* cap input rows for the captured run */

/* --------------------------------------------------------------------------
   IC2 reads L0.Extracted_BreastDrugEpisode (the Flatiron EHR drug-episode
   table, not distributed with the repo) and joins to crit1_mbc, the cohort
   IC1 builds. We seed a small stand-in for the L0 table and a small crit1_mbc
   so the script's drug-name filter, the '22APR2020'd date bound, and the
   MIN(sg_date) / GROUP BY index-date logic all run unchanged; the script reads
   WORK.Extracted_BreastDrugEpisode instead of L0.*.
   -------------------------------------------------------------------------- */

/* Cohort carried over from IC1 (only patientid is used by IC2's join) */
data crit1_mbc;
    length PatientID $8;
    input PatientID $;
    datalines;
P0001
P0002
P0005
P0007
;
run;

data Extracted_BreastDrugEpisode;
    length PatientID $8 DrugName $40;
    input PatientID $ EpisodeDate :date9. DrugName $40.;
    format EpisodeDate date9.;
    datalines;
P0001 01JUL2021 Sacituzumab Govitecan
P0001 15AUG2021 Sacituzumab Govitecan
P0002 10MAR2020 Sacituzumab Govitecan-hziy
P0002 20SEP2022 Sacituzumab Govitecan-hziy
P0005 05JUN2021 Paclitaxel
P0007 12FEB2023 SACITUZUMAB GOVITECAN
;
run;
