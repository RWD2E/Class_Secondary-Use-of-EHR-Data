/*
# Copyright (c) 2021-2025 University of Missouri                   
# Author: Xing Song, xsm7f@umsystem.edu                            
# File: lab_sql_cohort_extraction.sql                                                 
# Description: This script is for extracting an example study cohort
#  - Inclusion criteria: 
        - at least 2 diagnoses codes of ALS at different date
        - initial diagnosis code occured 
#  - Exposure: use of Riluzole
#  - Outcome: all-cause mortality
*/

/* 
create a patient table with following informations in separate columns: 
- DX_CNT: counts of distinct ALS diagnosis (on different dates)
- DX_DATE1: first date of ALS diagnosis
*/

-- collect all diagnoses about ALS
create or replace table all_als_dx as 
select * 
from deidentified_pcornet_cdm.cdm_c015r031.deid_diagnosis
where dx in ('335.20','G12.21')
-- where (dx_type = '09' and dx = '335.20') or (dx_type = '10' and dx='G12.21')
;
-- inspect the table
select * from all_als_dx limit 5;

-- gather some summary statistics needed for following steps
create or replace table als_incld as 
select patid, 
       count(distinct dx_date) as dx_cnt, 
       min(dx_date) as dx_date1
from all_als_dx
group by patid
;
-- inspect the table
select * from als_incld;

/*
create a patient demographic table with the following information: 
- AGE_AT_DX_DATE1: age at first ALS diagnosis date
- SEX
- RACE
- ETHNICITY
*/
-- attach needed information from demographic table and calculate age at index date
create or replace table als_incld_demo as
select als_incld.*,
       demo.sex, 
       demo.race,
       demo.hispanic as ethnicity,
       datediff(year,demo.birth_date,als_incld.dx_date1) as age_at_dx_date1
from als_incld
join deidentified_pcornet_cdm.cdm_c015r031.deid_demographic demo
on als_incld.patid = demo.patid
where als_incld.dx_cnt >= 2
;
-- check for duplicates
select count(*), count(distinct patid) 
from als_incld_demo
;
       
/*
create an exposure table of riluzole use status with following information collected in separate columns: 
- RILUZOLE_IND: an indicator of riluzole use
- RILUZOLE_DUR: days difference between first riluzole use and last riluzole use
*/
-- build a look up table of rxnorm_cui/rxcui codes for the medication with ingredient "riluzole"
create or replace table riluz_rxnorm as
select rxcui 
from ontology.rxnorm.rxnconso
where lower(str) like '%riluzol%' and sab = 'RXNORM'
;

-- collect all prescriptions of riluzole
create or replace table all_riluzole_als as
select pr.*
from deidentified_pcornet_cdm.cdm_c015r031.deid_prescribing pr
join als_incld_demo als 
on pr.patid = als.patid
join riluz_rxnorm rxn 
on pr.rxnorm_cui = rxn.rxcui
;
-- inspect the table
select * from all_riluzole_als
order by patid, rx_order_date;

-- gather some summary statistics for riluzole use
create or replace table als_riluz as
select patid, datediff(day, min(rx_start_date), max(rx_start_date)) as riluzole_dur, 
       1 as riluzole_ind 
from all_riluzole_als
group by patid
;
-- check for duplicates
select count(*), count(distinct patid) 
from als_riluz;


/*
create an outcome table with following information collected in separate columns: 
- OUTCOME_STATUS: an indicator of mortality: 1 if a death date is observed; 0 otherwise
- OUTCOME_DATE: date of the outcome: death date if DEATH_IND = 1; last encounter date if DEATH_IND = 0
*/
-- collect all death date data
create or replace table outcome_all as 
select distinct dth.patid, dth.death_date::date as death_date
from deidentified_pcornet_cdm.cdm_c015r031.deid_death dth 
join als_incld_demo als 
on dth.patid = als.patid 
;
-- duplicate check
select count(*), count(distinct patid)
from outcome_all;
-- it seems that there could be multiple death records per patient

-- create a helper table to identify conflict death dates
create or replace table outcome_death_dup as 
select patid, count(distinct death_date) as dup_cnt
from outcome_all 
group by patid
;

-- create final deduplicated death table 
create or replace table outcome_death_dedup as
select dth.patid, 
       1 as outcome_status,
       dth.death_date as outcome_date
from outcome_all dth 
where exists (
 select 1 from outcome_death_dup dup where dup.patid = dth.patid and dup.dup_cnt = 1
)
;
-- duplicate check
select count(*), count(distinct patid)
from outcome_death_dedup;

-- create a censor table for patients who are still alive
create or replace table outcome_censor as 
select patid, 
       max(admit_date) as censor_date
from deidentified_pcornet_cdm.cdm_c015r031.deid_encounter
where admit_date::date <= '2024-01-31'
group by patid
;

-- putting the death table and censor table together
create or replace table outcome_final as 
select demo.patid, 
       case when dth.outcome_status = 1 then 1 else 0 end as outcome_status,
       case when dth.outcome_date is not null then dth.outcome_date else cs.censor_date end as outcome_date
from als_incld_demo demo
left join outcome_death_dedup dth
on demo.patid = dth.patid
left join outcome_censor cs
on demo.patid = cs.patid
;
-- think about why I have to do "left join"

/*
now, putting everything together and create final analytic dataset
*/
create or replace table als_riluzole_death_final as 
select demo.*,
       case when r.riluzole_ind = 1 then 1 else 0 end as riluzole_ind,
       case when r.riluzole_dur is not null then r.riluzole_dur else 0 end as riluzole_dur,
       o.outcome_status,
       o.outcome_date
from  als_incld_demo demo
left join als_riluz r 
on demo.patid = r.patid
left join outcome_final o 
on demo.patid = o.patid
;
-- think about why I have to do "left join"

select count(*), count(distinct patid) from als_riluzole_death_final;

select * from als_riluzole_death_final limit 5;
