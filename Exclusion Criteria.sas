/* Step 1: Get diagnoses for IC3 patients in the 30 days before index */
proc sql;
    create table diag_window as
    select
        c.patientid,
        c.index_date,
        d.diagnosisdate,
        upcase(d.diagnosiscode) as diagnosiscode
    from ic3_hepatic c
    inner join L0.Diagnosis d
        on c.patientid = d.patientid
    where d.diagnosiscodesystem = "ICD-10-CM"
      and d.diagnosisdate < c.index_date
      and intck('day', d.diagnosisdate, c.index_date) between 1 and 30;
quit;

/* Step 2: Keep only diagnosis codes matching AEs */
proc sql;
    create table diag_ae as
    select *
    from diag_window
    where
          /* Febrile neutropenia */
          diagnosiscode between "D70.0" and "D70.9"
       or diagnosiscode between "R50.0" and "R50.9"

          /* Diarrhea */
       or diagnosiscode between "R19.0" and "R19.9"
       or diagnosiscode = "K59.1"

          /* Nausea */
       or diagnosiscode between "R11.0" and "R11.2"

          /* Vomiting */
       or diagnosiscode between "R11.10" and "R11.15"

          /* Fatigue */
       or diagnosiscode between "R53.0" and "R53.9"

          /* Abdominal pain */
       or diagnosiscode between "R10.0" and "R10.9"
       or diagnosiscode between "R10.A0" and "R10.A9"

          /* Dyspnea */
       or diagnosiscode between "R06.00" and "R06.09"

          /* Dizziness */
       or diagnosiscode = "R42"

          /* Dehydration */
       or diagnosiscode between "E86.0" and "E86.9"

          /* Sepsis */
       or diagnosiscode between "A40.0" and "A40.9"
       or diagnosiscode between "A41.0" and "A41.9";
quit;

/* Step 3: List patients who had an AE before index */
proc sql;
    create table ae_exclusion_list as
    select distinct patientid
    from diag_ae;
quit;

/* Step 4: Exclude those patients from the final analytic cohort */
proc sql;
    create table final_cohort as
    select *
    from ic3_hepatic
    where patientid not in (select patientid from ae_exclusion_list);
quit;
