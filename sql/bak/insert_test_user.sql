-- Inserts Jeanine as test user and make her a 
-- data owner of Brad Boyle transects

SET search_path TO :sch;

INSERT INTO party (
username,
fullname,
first_name,
middle_initials,
last_name,
email,
is_wp_user
)
SELECT
'jmcgann',
'Jeanine K. McGann',
'Jeanine',
'K.',
'McGann',
'jmcgann@email.arizona.edu',
1
;

INSERT INTO source_party (
source_id,
party_id,
party_role,
access_conditions,
is_primary
)
SELECT
(SELECT source_id FROM source WHERE source_name='Brad Boyle Forest Transects'),
(SELECT party_id FROM party WHERE fullname='Jeanine K. McGann'),
'data owner' ,
'offer coauthorship',
0
;
