/* S-1: Pull bilirubin and AST labs for patients who have an SG index date */
/* (Bilirubin ULN = 1.0 mg/dL; AST ULN = 40 IU/L) */
proc sql;
    create table ic3_labs_raw as
    select
        l.patientid,
        l.testdate,
        upcase(l.labcomponent) as labcomponent,
        l.testresultcleaned as labvalue,
        l.maxnormcleaned as uln,        /* dataset ULN for bilirubin or AST */
        i.index_date
    from L0.lab l
    inner join ic2_sg_index i
        on l.patientid = i.patientid
    where upcase(labcomponent) in (
            "TOTAL BILIRUBIN",
            "AST (ASPARTATE AMINOTRANSFERASE)"
          );
quit;


/* S-2: Identify moderate hepatic impairment 
(bilirubin >1.5×ULN to ≤3×ULN; ULN for bilirubin = 1.0) */
proc sql;
    create table ic3_moderate as
    select
        patientid,
        testdate,
        labvalue as bili_value,
        uln as bili_uln,
        index_date
    from ic3_labs_raw
    where labcomponent = "TOTAL BILIRUBIN"
      and labvalue > 1.5 * uln
      and labvalue <= 3 * uln;
quit;


/* S-3: Identify normal hepatic function 
        (bilirubin ≤ ULN AND AST ≤ 40; AST ULN is fixed at 40 IU/L) */
proc sql;
    /* put bilirubin + AST on one row so we can evaluate them together */
    create table ic3_normal_prep as
    select
        patientid,
        max(case when labcomponent = "TOTAL BILIRUBIN"
                 then labvalue end) as bili_value,
        max(case when labcomponent = "TOTAL BILIRUBIN"
                 then uln end)      as bili_uln,
        max(case when labcomponent =
                 "AST (ASPARTATE AMINOTRANSFERASE)"
                 then labvalue end) as ast_value,
        max(index_date) as index_date,
        max(testdate)   as testdate
    from ic3_labs_raw
    group by patientid;
quit;

proc sql;
    create table ic3_normal as
    select
        patientid,
        testdate,
        bili_value,
        bili_uln,
        ast_value,
        index_date
    from ic3_normal_prep
    where bili_value <= bili_uln     /* bilirubin normal (≤1.0 ULN) */
      and ast_value <= 40;           /* AST must be ≤ 40 IU/L */
quit;


/* S-4: Keep only labs within the 1-year window before SG index date */
proc sql;
    create table ic3_hepatic as
    select distinct patientid
    from (
        select patientid, testdate, index_date from ic3_normal
        union corr
        select patientid, testdate, index_date from ic3_moderate
    )
    where testdate <= index_date
      and intck('day', testdate, index_date) between 0 and 365;
quit;
