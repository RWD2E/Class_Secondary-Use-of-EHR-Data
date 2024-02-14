/*
# Copyright (c) 2021-2025 University of Missouri                   
# Author: Xing Song, xsm7f@umsystem.edu                            
# File: sp_dcl_utils.sql                                                 
# Description: DCL utilities for creating new user and roles 
ref: 
- https://docs.snowflake.com/en/user-guide/admin-user-management.html#creating-users
- https://docs.snowflake.com/en/sql-reference/sql/grant-privilege.html
*/

-- create class member role
CREATE OR REPLACE PROCEDURE dcl_new_user(
    USER_ACCOUNT STRING,
    USER_EMAIL_DOMAIN STRING,
    FIRST_NAME STRING,
    LAST_NAME STRING
)
RETURNS VARIANT NOT NULL
LANGUAGE javascript
AS
$$
/** create new snowflake user and workspace
 * @param {string} USER_ACCOUNT: user account name, usually equivalent to their institutional id
 * @param {string} USER_EMAIl_DOMAIN: email domain, usually their institutional email domain (most generic alias)
 * @param {string} FIRST_NAME: user's first name 
 * @param {string} LAST_NAME: user's last name 
 * each user will automatically be assigned with a read-write database (<USER_ACCOUNT>_DB) as their individual workspace, 
**/

var msg_as_json = {};

// Form user email and role
var NAME = USER_ACCOUNT.toUpperCase()
var USER_EMAIL = USER_ACCOUNT + '@' + USER_EMAIL_DOMAIN;
var USER_ROLE = 'CLASS_MEMBER_' + NAME;

// Create role
try {
    var dcl_role_stmt = snowflake.createStatement({sqlText:`CREATE ROLE `+ USER_ROLE +`;`});
    dcl_role_stmt.execute();
    msg_as_json["role"] = "successfully created the new role"
} catch (err) {
    msg_as_json["role"] = err;
}

// Create user
try {
    var dcl_user_qry = `CREATE USER `+ NAME +` 
                        password = '' 
                        login_name = '`+ USER_EMAIL +`' 
                        first_name = '`+ FIRST_NAME +`' 
                        last_name = '`+ LAST_NAME +`' 
                        display_name = '`+ LAST_NAME +`,`+ FIRST_NAME +`'
                        email = '`+ USER_EMAIL +`' 
                        must_change_password = FALSE;`;
    var dcl_user_stmt = snowflake.createStatement({sqlText:dcl_user_qry});
    dcl_user_stmt.execute();
    msg_as_json["user"] = "successfully created the new role"
} catch (err) {
    msg_as_json["user"] = err;
}

// Assign user to the role
try {
    var dcl_user_role_stmt = snowflake.createStatement({sqlText:`GRANT ROLE `+ USER_ROLE +` TO USER `+ NAME +`;`});
    dcl_user_role_stmt.execute();
    msg_as_json["grant-role"] = "successfully assign the user's role:" + USER_ROLE;
} catch (err) {
    msg_as_json["grant-role"] = err;
}

return msg_as_json
$$
;

CREATE OR REPLACE PROCEDURE dcl_role_spec(
    USER_ROLE STRING,
    WH_NAME STRING,
    READONLY_DB ARRAY
)
RETURNS VARIANT NOT NULL
LANGUAGE javascript
as
$$
/** create new snowflake user and workspace
 * @param {string} USER_ROLE: user role to be specified
 * @param {string} Wh_NAME: pre-defined WAREHOUSE for the role to use
 * @param {array} READONLY_DB: a list of readonly databases
 * each user role will automatically be assigned with a read-write database (<USER_ROLE>_DB) as their individual workspace
**/

var msg_as_json = {};

// Form read-write DB name
var DB_NAME = USER_ROLE + '_DB';

// Create read-write DB
try {
    var ddl_db_qry = `CREATE DATABASE `+ DB_NAME +`;`;
    var ddl_db_run = snowflake.createStatement({sqlText:ddl_db_qry});
    ddl_db_run.execute();
    msg_as_json["read-write-db"] = "successfully created the read-write database"
} catch (err) {
    msg_as_json["read-write-db"] = err;
}

// Bundled Granting to the read-write database
try {
    var grant_use_db = snowflake.createStatement({sqlText:`GRANT USAGE ON DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_create_schema = snowflake.createStatement({sqlText:`GRANT CREATE SCHEMA ON DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_cur_s = snowflake.createStatement({sqlText:`GRANT ALL ON ALL SCHEMAS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_cur_t = snowflake.createStatement({sqlText:`GRANT ALL ON ALL TABLES IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_cur_v = snowflake.createStatement({sqlText:`GRANT ALL ON ALL VIEWS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_fut_s = snowflake.createStatement({sqlText:`GRANT ALL ON FUTURE SCHEMAS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_fut_t = snowflake.createStatement({sqlText:`GRANT ALL ON FUTURE TABLES IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_fut_v = snowflake.createStatement({sqlText:`GRANT ALL ON FUTURE VIEWS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    grant_use_db.execute();
    grant_create_schema.execute();
    grant_cur_s.execute();
    grant_cur_t.execute();
    grant_cur_v.execute();
    grant_fut_s.execute();
    grant_fut_t.execute();
    grant_fut_v.execute();
    msg_as_json["grant-read-write"] = "successfully grant access to the read-write database:" + DB_NAME;
} catch(err){
    msg_as_json["read-write-db"] = err;
}

// Bundled Granting to the list of read-only databases
var i;
for(i=0; i<READONLY_DB.length; i++){
  var DB_NAME = READONLY_DB[i].toString();
  if(DB_NAME == 'SHARED_DB'){
    var grant_cur_db = snowflake.createStatement({sqlText:`GRANT USAGE ON DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_cur_s = snowflake.createStatement({sqlText:`GRANT ALL ON ALL SCHEMAS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_cur_t = snowflake.createStatement({sqlText:`GRANT ALL ON ALL TABLES IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_cur_v = snowflake.createStatement({sqlText:`GRANT ALL ON ALL VIEWS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_fut_s = snowflake.createStatement({sqlText:`GRANT ALL ON FUTURE SCHEMAS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_fut_t = snowflake.createStatement({sqlText:`GRANT ALL ON FUTURE TABLES IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    var grant_fut_v = snowflake.createStatement({sqlText:`GRANT ALL ON FUTURE VIEWS IN DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    grant_cur_db.execute();
    grant_cur_s.execute();
    grant_cur_t.execute();
    grant_cur_v.execute();
    grant_fut_s.execute();
    grant_fut_t.execute();
    grant_fut_v.execute();
  } else {
    var grant_imp_db = snowflake.createStatement({sqlText:`GRANT IMPORTED PRIVILEGES ON DATABASE `+ DB_NAME +` TO ROLE `+ USER_ROLE +`;`});
    grant_imp_db.execute();
  }
  msg_as_json["grant-readonly"+i] = "successfully grant access to the read-only database:" + DB_NAME;
}

// Grant access to pre-defined warehouse
var grant_wh = snowflake.createStatement({sqlText:`GRANT USAGE ON WAREHOUSE `+ WH_NAME +` TO ROLE `+ USER_ROLE +`;`});
grant_wh.execute();
msg_as_json["grant-warehouse"] = "successfully grant access to the warehouse:" + WH_NAME;

return msg_as_json;
$$
;
