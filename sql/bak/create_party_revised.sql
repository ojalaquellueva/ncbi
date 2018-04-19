-- --------------------------------------------------------
-- Generate temporary table party_revised
-- --------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS party_revised;
CREATE TABLE party_revised (
party_id integer not null,
accepted_party_id integer default null,
username varchar(25) default null,
pwd varchar(25) default null,
is_person integer default 1,
is_core_bien_member integer default 0,
is_bien_data_owner integer default 0,
is_proximate_provider integer default 0, 
fullname text not null,
title varchar(25) default null,
prefix varchar(25) default null,
first_name varchar(50) default null,
middle_initials varchar(25) default null,
last_name varchar(50) default null,
last_name2 varchar(50) default null,
suffix varchar(25) default null, 
address1 varchar(50) default null, 
address2 varchar(50) default null,
city varchar(50) default null,
state_province varchar(50) default null,
postal_code varchar(25) default null,
country varchar(50) default null,
email text default null,
email2 text default null,
phone text default null,
phone2 text default null,
url text default null,
is_wp_user integer not null default 0,
wp_id integer default null
);

ALTER TABLE party_revised OWNER TO :user_adm;
