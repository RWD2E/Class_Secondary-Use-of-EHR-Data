/*
# Copyright (c) 2021-2025 University of Missouri                   
# Author: Xing Song, xsm7f@umsystem.edu                            
# File: als_example.sql                                                 
# Description: This script is for generating the example ALS cohort dataset for in-class exercise
*/

set cdm_schema = 'DEIDENTIFIED_PCORNET_CDM.CDM_2022_OCT';
set diagnosis = $cdm_schema || '.DEID_DIAGNOSIS';
set demographic = $cdm_schema || '.DEID_DEMOGRAPHIC';
set death = $cdm_schema || '.DEID_DEATH';
set procedures = $cdm_schema || '.DEID_PROCEDURES';
set dispensing = $cdm_schema || '.DEID_DISPENSING';
set encounter = $cdm_schema || '.DEID_ENCOUNTER';
set prescribing = $cdm_schema || '.DEID_PRESCRIBING';

/* ALS_INIT; first ALS symptom  */
create or replace table ALS_INIT as
select patid,
       min(dx_date::date) as first_ALS_date,
       count(distinct dx_date::date) as n_claims
from identifier($diagnosis)
where (DX = 'G12.21' or DX = '335.20')
group by patid;

create or replace table ALS_CENSOR as
select a.patid, 
       max(nvl(a.discharge_date,a.admit_date)) as censor_date
from identifier($encounter) a
where exists (select 1 from als_init b where a.patid = b.patid)
group by a.patid
;

/*ALS Patient Table*/
create or replace table ALS_PT_TABLE as
select distinct
       e.patid,
       e.first_ALS_date,
       d.BIRTH_DATE,
       round(datediff(day,d.BIRTH_DATE,e.FIRST_ALS_DATE)/365.25) as AGE_AT_ALS1DX,
       d.SEX,
       d.RACE,
       d.HISPANIC,
       dth.DEATH_DATE::date as death_date,
       datediff(day,e.FIRST_ALS_DATE,dth.DEATH_DATE::date) as DAYS_ALS1DX_TO_DEATH,
       datediff(day,e.FIRST_ALS_DATE,c.censor_date) as DAYS_ALS1DX_TO_CENSOR
from ALS_INIT e
join identifier($DEMOGRAPHIC) d on e.patid = d.patid
left join identifier($DEATH) dth on e.patid = dth.patid
left join ALS_CENSOR c on e.patid = c.patid
where e.n_claims >=2
;

create or replace table ALS_RILUZOLE as
with riluz_cui as (
    select rxcui, str
    from ontology.rxnorm.rxnconso
    where lower(STR) like '%riluz%'
)
select distinct
       p.PATID,
       p.ENCOUNTERID,
       p.RX_ORDER_DATE::date as RX_ORDER_DATE,
       datediff(day,pt.first_ALS_date,p.RX_ORDER_DATE::date) as DAYS_ORDER_SINCE_ALS1DX,
       p.RX_START_DATE::date as RX_START_DATE,
       datediff(day,pt.first_ALS_date,p.RX_START_DATE::date) as DAYS_START_SINCE_ALS1DX,
       p.RX_END_DATE::date as RX_END_DATE,
       p.RX_DOSE_ORDERED,
       p.RX_DOSE_ORDERED_UNIT,
       p.RX_DOSE_FORM,
       p.RX_REFILLS,
       p.RX_DAYS_SUPPLY,
       p.RX_FREQUENCY
       --,p.RXNORM_CUI
       --,p.RAW_RX_MED_NAME
from identifier($prescribing) p
join ALS_PT_TABLE pt on p.patid = pt.patid
where exists (select 1 from riluz_cui
              where riluz_cui.rxcui = rxnorm_cui) or 
      lower(RAW_RX_MED_NAME) like '%riluz%'
order by patid, RX_START_DATE
;

