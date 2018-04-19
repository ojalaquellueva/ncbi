-- --------------------------------------------------------
-- Generate temporary table wp_users
-- --------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS wp_users;
CREATE TABLE wp_users (
ID integer not null primary key,
user_login varchar(50) default null,
user_pass text default null,
user_nicename text default null,
user_email text default null,
user_url text default null,
user_registered text default null,
user_activation_key text default null,
user_status text default null,
display_name text default null
);

ALTER TABLE wp_users OWNER TO :user_adm;
