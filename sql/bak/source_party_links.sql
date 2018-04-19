-- --------------------------------------------------------
-- --------------------------------------------------------
-- Link sources to users & add party_roles
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- --------------------------------------------------------
-- Primary contacts
-- --------------------------------------------------------

INSERT INTO source_party (
party_id,
source_id,
party_role,
is_primary
)
SELECT
b.party_id,
a.source_id,
'primary contact',
1
FROM source a JOIN party b
ON a.primary_contact_fullname=b.fullname
;

-- --------------------------------------------------------
-- data owners
-- --------------------------------------------------------

INSERT INTO source_party (
party_id,
source_id,
party_role,
is_primary
)
SELECT
b.party_id,
a.source_id,
'data owner',
1
FROM source a JOIN party b
ON a.primary_contact_fullname=b.fullname
WHERE a.is_provider=0
;

-- --------------------------------------------------------
-- data providers
-- --------------------------------------------------------

INSERT INTO source_party (
party_id,
source_id,
party_role,
is_primary
)
SELECT
b.party_id,
a.source_id,
'proximate provider',
0
FROM source a JOIN party b
ON a.primary_contact_fullname=b.fullname
WHERE a.is_provider=1
;

-- --------------------------------------------------------
-- update metadata in table source
-- --------------------------------------------------------

UPDATE party a
SET is_bien_data_owner=1
FROM source_party b
WHERE a.party_id=b.party_id
AND b.party_role='data owner' OR b.is_primary=1
;

UPDATE party a
SET is_proximate_provider=1
FROM source_party b
WHERE a.party_id=b.party_id
AND b.party_role='proximate provider'
;

-- --------------------------------------------------------
-- Remove temporary FK
-- --------------------------------------------------------

ALTER TABLE source DROP COLUMN primary_contact_fullname;
