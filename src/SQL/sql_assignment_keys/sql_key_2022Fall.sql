/*
# Copyright (c) 2021-2025 University of Missouri                   
# Author: Xing Song, xsm7f@umsystem.edu                            
# File: sql_assignment_key.sql                                                 
# Description: Solution key for SQL assignment (HMI7001, 2022 Fall)
*/
use role class_member_xsm7f;
use warehouse nextgenbmi_wh;
use database class_member_xsm7f_db;
create schema if not exists HMI7001_SQL_HW;
use schema HMI7001_SQL_HW;
select * from DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_diagnosis;
/*
Q1: How many patients have ever been diagnosed with at least 1 ALS diagnosis code (ICD9: 335.20; ICD10: G12.21)? 
    How many have at least 2 diagnosis codes assigned at on different dates? 
*/
create or replace table pt_als_icd_cnt as 
select patid,
       min(dx_date::date) as als_1dx_date,
       count(distinct dx_date::date) as n_icd_diff_days
from DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_diagnosis
where (DX_TYPE = '10' and DX = 'G12.21') or 
      (DX_TYPE = '09' and DX = '335.20')
group by patid;

-- number of patients with at least 1 ALS diagnosis code
select count(distinct patid) from pt_als_icd_cnt;
-- 420

-- number of patients with at least 1 ALS diagnosis codes
select count(distinct patid) from pt_als_icd_cnt where n_icd_diff_days > 1;
-- 252

/*
Q2: Among those who have at least 1 ALS diagnosis, what is the mean and median age at their first ALS diagnosis? 
    Remove patients whose age at diagnosis is above 90 years, and what is the mean and median age at first ALS now? 
*/
create or replace table pt_als_age_sex as
select a.patid,
       a.als_1dx_date,
       d.birth_date,
       round(datediff(day,d.birth_date,a.als_1dx_date)/365.25) as age_at_1dx,
       d.sex
from pt_als_icd_cnt a
join DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_demographic d
on a.patid = d.patid
;
  
--  mean and median age at their first ALS diagnosis?
select round(avg(age_at_1dx)) as mean_age, 
       median(age_at_1dx) as median_age 
from pt_als_age_sex;
-- mean:61, median: 62 

--  mean and median age at their first ALS diagnosis after excluding those who are above 90 years old?
select round(avg(age_at_1dx)) as mean_age, 
       median(age_at_1dx) as median_age 
from pt_als_age_sex
where age_at_1dx <= 90;
-- mean:61, median: 62 

/*
Q3: Among those who have at least 1 ALS diagnosis, how many females are in this cohort? How many males? 
*/
select sex, count(distinct patid) 
from pt_als_age_sex
group by sex
;
-- F	179
-- M	241


/*
Q4: Create a patient table for ALS patients (you can name it ALS_PT) with the following specifications and 
    order by PATID
*/
create or replace table als_pt as
select a.patid,
       a.als_1dx_date,
       a.age_at_1dx,
       d.sex,
       d.race,
       d.hispanic
from pt_als_age_sex a
join DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_demographic d
on a.patid = d.patid
order by a.patid
;

select * from als_pt limit 5;

-- PATID	ALS_1DX_DATE	AGE_AT_1DX	SEX	RACE	HISPANIC
-- 2153390	2012-08-31	    42	        F	05	    N
-- 2157012	2002-07-31	    2	        F	05	    N
-- 2159487	2008-06-16	    64	        F	05	    N
-- 2174833	2013-06-04	    55	        M	05	    N
-- 2177374	2014-02-21	    55	        M	05	    N

/*
Q5: Create a mortality outcome table for the ALS patients who have passed away (You can call it ALS_PT_DEATH), 
    with the following specifications and order by PATID
*/

-- detect duplicates in death table
select patid, count(distinct death_date) 
from DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_death
group by patid
having count(distinct death_date) > 1
;

create or replace table als_death_unique_date as
select a.patid,
       min(d.death_date::date) as death_date
from als_pt a
join DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_death d
on a.patid = d.patid
group by a.patid
;

create or replace table als_pt_death as
select a.patid,
       d.death_date as endpoint_date,
       datediff(day,a.als_1dx_date,d.death_date) as days_since_als_dx1
from als_pt a
join als_death_unique_date d
on a.patid = d.patid
order by a.patid
;

select * from als_pt_death limit 5;
-- PATID	ENDPOINT_DATE	DAYS_SINCE_ALS_DX1
-- 1467756	2018-11-14	    1,625
-- 1470566	2010-07-24	    141
-- 147333	2008-05-27	    637
-- 1485138	2010-10-20	    167
-- 1485257	2011-05-23	    329

/*
Q6: Create a censor table for the ALS patients who is still alive (You can call it ALS_PT_ALIVE), 
    with the following specifications and order by PATID
*/
create or replace table als_alive_last_enc as
select a.patid,
       max(nvl(e.discharge_date::date,e.admit_date::date)) as last_enc_date
from als_pt a
join DEIDENTIFIED_PCORNET_CDM.CDM_2022_JULY.deid_encounter e
on a.patid = e.patid
where not exists (select 1 from als_pt_death d where a.patid = d.patid)
group by a.patid
;

-- sanity check, make sure that the alive patient and death patients still add up to the total patients
select count(distinct patid) from 
(select patid from als_alive_last_enc
 union 
 select patid from als_pt_death)
;
-- 420 -- check passed! 

create or replace table als_pt_alive as
select a.patid,
       a.last_enc_date as endpoint_date,
       datediff(day,b.birth_date, a.last_enc_date) as days_since_als_dx1
from als_alive_last_enc a
join pt_als_age_sex b
on a.patid = b.patid
order by a.patid
;

select * from als_pt_alive limit 5;

-- PATID	ENDPOINT_DATE	DAYS_SINCE_ALS_DX1
-- 1858012	2020-11-11	    10,027
-- 1858866	2018-12-06	    23,064
-- 1861515	2021-02-08	    20,048
-- 1882593	2021-04-29	    27,433
-- 1888157	2018-12-25	    24,568


/*
Q7: Using tables created for Q4 – Q6, answer the following questions:
	a. How many ALS patients have survived for at least 5 (≥ 5) years? 
	b. How many ALS patients have survived for less than 3 years (< 3)?
	c. What is the overall mortality rate of ALS patients? 
	d. What is the risk ratio/relative risk of mortality between female and male ALS patients? 
	e. What is the risk ratio/relative risk of mortality between white and non-white patients?
	f. What is the risk ratio/relative risk of mortality between patients with age at first ALS diagnosis <65 and ≥ 65 years old? 
	g. What is the risk ratio/relative risk of mortality between patients with ethnicity/hispanic information and without? 
*/

-- a. How many ALS patients have survived for at least 5 (≥ 5) years?
select count(distinct patid) from 
(
 select patid from als_pt_alive where days_since_als_dx1/365.25 >= 5 
 union
 select patid from als_pt_death where days_since_als_dx1/365.25 >= 5
);
-- 222

-- b. How many ALS patients have survived for less than 3 years (< 3)?
select count(distinct patid) from als_pt_death where days_since_als_dx1/365.25 < 3;
-- 172

-- c. What is the overall mortality rate of ALS patients? 
-- from Q1, we know that the total number of patients N = 420
select count(distinct patid)/420 from als_pt_death;
-- 0.511905

-- d. What is the risk ratio/relative risk of mortality between female and male ALS patients?
create or replace table als_by_sex as
select sex, count(distinct patid) as pat_cnt
from als_pt
group by sex
;

create or replace table als_death_by_sex as
select b.sex,
       count(distinct a.patid) as pat_cnt
from als_pt_death a 
join als_pt b on a.patid = b.patid 
group by b.sex
;

create or replace table death_ir_by_sex as
select a.sex,
       a.pat_cnt as denom, 
       b.pat_cnt as num, 
       b.pat_cnt/a.pat_cnt as incidence_rate
from als_by_sex a
join als_death_by_sex b
on a.sex = b.sex
;

-- here I'm introducing a new "pivot" function for direct RR calculation,
-- but you can definitely perform the calculation by hand
select incidence_rate_f,
       incidence_rate_m,
       incidence_rate_f/incidence_rate_m as risk_ratio_by_sex 
from 
(select sex, incidence_rate from death_ir_by_sex)
    pivot (min(incidence_rate) 
       for sex in ('F','M'))
       as p(incidence_rate_f,incidence_rate_m)
;
-- INCIDENCE_RATE_F	INCIDENCE_RATE_M	RISK_RATIO_BY_SEX
-- 0.502793	        0.518672	        0.969385276244


-- e. What is the risk ratio/relative risk of mortality between white and non-white patients?
create or replace table als_race_grp as
select patid, 
       case when race = '05' then 'W'
            when race in ('NI','UN') or race is null then 'UN'
            else 'NW'
            end as race_grp
from als_pt
;

create or replace table als_by_race as
select race_grp, 
       count(distinct patid) as pat_cnt
from als_race_grp
group by race_grp
;

create or replace table als_death_by_race as
select b.race_grp,
       count(distinct a.patid) as pat_cnt
from als_pt_death a 
join als_race_grp b on a.patid = b.patid 
group by b.race_grp
;

create or replace table death_ir_by_race as
select a.race_grp,
       a.pat_cnt as denom, 
       b.pat_cnt as num, 
       b.pat_cnt/a.pat_cnt as incidence_rate
from als_by_race a
join als_death_by_race b
on a.race_grp = b.race_grp
;

select incidence_rate_w,
       incidence_rate_nw,
       incidence_rate_un,
       incidence_rate_w/incidence_rate_nw as risk_ratio_by_race 
from 
(select race_grp, incidence_rate from death_ir_by_race)
    pivot (min(incidence_rate) 
       for race_grp in ('W','NW','UN'))
       as p(incidence_rate_w,incidence_rate_nw,incidence_rate_un)
;

-- INCIDENCE_RATE_W	INCIDENCE_RATE_NW	INCIDENCE_RATE_UN	RISK_RATIO_BY_RACE
-- 0.513021	0.380952	0.666667	1.346681471681

-- f. What is the risk ratio/relative risk of mortality between patients with age at first ALS diagnosis <65 and ≥ 65 years old? 
create or replace table als_age_grp as
select patid, 
       case when age_at_1dx>=65 then 'age_ge65'
            else 'age_lt65'
            end as age_grp
from als_pt
;

create or replace table als_by_age as
select age_grp, 
       count(distinct patid) as pat_cnt
from als_age_grp
group by age_grp
;

create or replace table als_death_by_age as
select b.age_grp,
       count(distinct a.patid) as pat_cnt
from als_pt_death a 
join als_age_grp b on a.patid = b.patid 
group by b.age_grp
;

create or replace table death_ir_by_age as
select a.age_grp,
       a.pat_cnt as denom, 
       b.pat_cnt as num, 
       b.pat_cnt/a.pat_cnt as incidence_rate
from als_by_age a
join als_death_by_age b
on a.age_grp = b.age_grp
;

select incidence_rate_age_ge65,
       incidence_rate_age_lt65,
       incidence_rate_age_ge65/incidence_rate_age_lt65 as risk_ratio_by_age 
from 
(select age_grp, incidence_rate from death_ir_by_age)
    pivot (min(incidence_rate) 
       for age_grp in ('age_ge65','age_lt65'))
       as p(incidence_rate_age_ge65,incidence_rate_age_lt65)
;
-- INCIDENCE_RATE_AGE_GE65	INCIDENCE_RATE_AGE_LT65	 RISK_RATIO_BY_AGE
-- 0.635294	                0.428	                 1.484331775701


-- g. What is the risk ratio/relative risk of mortality between patients with ethnicity/hispanic information and without? 
create or replace table als_hispanic_un as
select patid, 
       case when hispanic in ('UN','NI') or hispanic is null then 'unknown'
            else 'known' 
            end as hispanic_miss
from als_pt
;

create or replace table als_by_hispanic as
select hispanic_miss, 
       count(distinct patid) as pat_cnt
from als_hispanic_un
group by hispanic_miss
;

create or replace table als_death_by_hispanic as
select b.hispanic_miss,
       count(distinct a.patid) as pat_cnt
from als_pt_death a 
join als_hispanic_un b on a.patid = b.patid 
group by b.hispanic_miss
;

create or replace table death_ir_by_hispanic as
select a.hispanic_miss,
       a.pat_cnt as denom, 
       b.pat_cnt as num, 
       b.pat_cnt/a.pat_cnt as incidence_rate
from als_by_hispanic a
join als_death_by_hispanic b
on a.hispanic_miss = b.hispanic_miss
;

select incidence_rate_unk,
       incidence_rate_kwn,
       incidence_rate_unk/incidence_rate_kwn as risk_ratio_by_race 
from 
(select hispanic_miss, incidence_rate from death_ir_by_hispanic)
    pivot (min(incidence_rate) 
       for hispanic_miss in ('unknown','known'))
       as p(incidence_rate_unk,incidence_rate_kwn)
;

-- INCIDENCE_RATE_UNK	INCIDENCE_RATE_KWN	 RISK_RATIO_BY_RACE
-- 0.841584	            0.407524	         2.0651151834
