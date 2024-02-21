/*
# Copyright (c) 2021-2025 University of Missouri                   
# Author: Xing Song, xsm7f@umsystem.edu                            
# File: lab_sql_cohort_extraction.sql                                                 
# Description: This script is for extracting an example study cohort
#  - Inclusion criteria: 
        - at least 2 diagnoses codes of ALS at different time
        - initial diagnosis code occured 
#  - Exposure: use of Riluzole
#  - Outcome: all-cause mortality
*/

/* 
create a patient table with following informations in separate columns: 
- DX_CNT: counts of distinct ALS diagnosis (on different dates)
- DX_DATE1: first date of ALS diagnosis
*/

/*
create a patient demographic table with the following information: 
- AGE_AT_DX_DATE1: age at first ALS diagnosis date
- SEX
- RACE
- ETHNICITY
*/

/*
create an exposure table of riluzole use status with following information collected in separate columns: 
- RILUZOLE_IND: an indicator of riluzole use
- RILUZOLE_DUR: days difference between first riluzole use and last riluzole use
*/

/*
create an outcome table with following information collected in separate columns: 
- OUTCOME_STATUS: an indicator of mortality: 1 if a death date is observed; 0 otherwise
- OUTCOME_DATE: date of the outcome: death date if DEATH_IND = 1; last encounter date if DEATH_IND = 0
*/


