-- --------------------------------------------------------
-- --------------------------------------------------------
-- Merge wordpress user information into user table
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- Flag users already present in wp database
UPDATE party a
SET 
is_wp_user=1,
username=b.user_login,
wp_id=b.id
FROM wp_users b
WHERE a.email=b.user_email
;

ALTER TABLE wp_users
ADD COLUMN is_in_bien_db integer default 0
;

CREATE INDEX ON wp_users (is_in_bien_db);

UPDATE wp_users a
SET 
is_in_bien_db=1
FROM party b
WHERE a.user_email=b.email
;

-- Insert new users
INSERT INTO party (
fullname,
first_name,
last_name,
username,
wp_id,
email,
is_wp_user
)
SELECT 
'MISSING',
'MISSING',
'MISSING',
user_login,
id,
user_email,
1
FROM wp_users 
WHERE is_in_bien_db=0
AND user_nicename NOT IN (
'admin', 'testuser','editor_testuser','contributor_testuser', 'test_provider'
);

DROP TABLE wp_users;
