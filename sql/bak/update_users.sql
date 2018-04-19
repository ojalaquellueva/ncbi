-- --------------------------------------------------------
-- --------------------------------------------------------
-- Merge wordpress user information into user table
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- Update existing users
UPDATE party a
SET 
accepted_party_id=b.accepted_party_id,
username=b.username,
pwd=b.pwd,
is_person=b.is_person,
is_core_bien_member=b.is_core_bien_member,
is_bien_data_owner=b.is_bien_data_owner,
is_proximate_provider=b.is_proximate_provider,
fullname=b.fullname,
title=b.title,
prefix=b.prefix,
first_name=b.first_name,
middle_initials=b.middle_initials,
last_name=b.last_name,
last_name2=b.last_name2,
suffix=b.suffix,
address1=b.address1,
address2=b.address2,
city=b.city,
state_province=b.state_province,
postal_code=b.postal_code,
country=b.country,
email=b.email,
email2=b.email2,
phone=b.phone,
phone2=b.phone2,
url=b.url,
is_wp_user=b.is_wp_user,
wp_id=b.wp_id
FROM party_revised b
WHERE a.party_id=b.party_id
;

-- Insert new users, if any
-- Note that recursive FK accepted_party_id not imported
INSERT INTO party (
username,
pwd,
is_person,
is_core_bien_member,
is_bien_data_owner,
is_proximate_provider,
fullname,
title,
prefix,
first_name,
middle_initials,
last_name,
last_name2,
suffix,
address1,
address2,
city,
state_province,
postal_code,
country,
email,
email2,
phone,
phone2,
url,
is_wp_user,
wp_id
)
SELECT
a.username,
a.pwd,
a.is_person,
a.is_core_bien_member,
a.is_bien_data_owner,
a.is_proximate_provider,
a.fullname,
a.title,
a.prefix,
a.first_name,
a.middle_initials,
a.last_name,
a.last_name2,
a.suffix,
a.address1,
a.address2,
a.city,
a.state_province,
a.postal_code,
a.country,
a.email,
a.email2,
a.phone,
a.phone2,
a.url,
a.is_wp_user,
a.wp_id
FROM party_revised a LEFT JOIN party b
ON a.party_id=b.party_id
WHERE b.party_id IS NULL
;

