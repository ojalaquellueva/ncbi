-- --------------------------------------------------------
-- Import key user data from previous user database
-- (persons only)
-- --------------------------------------------------------

-- 
-- NOTE: Assume party_id constant between versions!
-- 

SET search_path TO :sch;

-- Update existing users based on full name
UPDATE party a
SET 
is_core_bien_member=b.is_core_bien_member,
is_bien_data_owner=b.is_bien_data_owner,
is_proximate_provider=b.is_proximate_provider,
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
email=
CASE
WHEN a.email IS NULL THEN b.email
ELSE a.email
END,
email2=
CASE
WHEN a.email2 IS NULL THEN b.email2
ELSE a.email2
END,
phone=b.phone,
phone2=b.phone2,
url=b.url
FROM :sch_prev.party b
WHERE a.fullname=b.fullname
AND a.is_person=1
AND b.is_person=1
AND b.accepted_party_id is null
;

-- User email to populate data for wordpress users missing fullname
UPDATE party a
SET 
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
phone=b.phone,
phone2=b.phone2,
url=b.url
FROM :sch_prev.party b
WHERE lower(a.email)=lower(b.email)
AND a.is_person=1
AND b.is_person=1
AND b.accepted_party_id is null
AND (a.fullname IS NULL OR a.fullname='MISSING')
;