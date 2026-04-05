/*--- Step 1: Identify SG episodes for mBC patients  ---*/
proc sql;
    create table sg_episode as
    select
        e.patientid,
        e.episodedate as sg_date
    from L0.Extracted_BreastDrugEpisode e
    inner join crit1_mbc m                
        on e.patientid = m.patientid
    where upcase(e.drugname) in (
            "SACITUZUMAB GOVITECAN",
            "SACITUZUMAB GOVITECAN-HZIY"
          )
      and e.episodedate >= '22APR2020'd;
quit;

/*--- Step 2: Determine earliest SG episode date as IC2 index date ---*/
proc sql;
    create table ic2_sg_index as
    select
        patientid,
        min(sg_date) as index_date
    from sg_episode
    group by patientid;
quit;
