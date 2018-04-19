-- --------------------------------------------------------
-- --------------------------------------------------------
-- Generate tables for users schema
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- --------------------------------------------------------
-- Insert sources
-- --------------------------------------------------------

-- Add temporary FK to primary contact fullname
ALTER TABLE source
ADD COLUMN primary_contact_fullname TEXT DEFAULT NULL;
CREATE INDEX source_primary_contact_fullname_idx ON source (primary_contact_fullname)
;

-- Insert distinct sources
INSERT INTO source (
source_name
)
SELECT DISTINCT
source_name
FROM :sch_adb.datasource
WHERE source_name IS NOT NULL
;

-- Insert remaining details. 
-- Done as separate step in case of non-unique values
-- Currently none, but this will choose one value at random
-- if anomalies exist. Not concerned about preserving
-- anomalous entires than maintaining relations integrity
UPDATE source a
SET
source_fullname=b.source_fullname,
is_provider=
CASE 
WHEN b.source_type LIKE '%provider%' THEN 1
ELSE 0
END,
observation_type=b.observation_type,
is_herbarium=b.is_herbarium,
url=b.source_url,
citation=b.source_citation,
access_conditions=b.access_conditions,
access_level=b.access_level,
primary_contact_fullname=b.primary_contact_fullname
FROM :sch_adb.datasource b
WHERE a.source_name=b.source_name
;

-- Insert traits dataset, and fix missing source name
INSERT INTO source (
source_name,
source_fullname,
is_provider,
observation_type,
is_herbarium,
url,
citation,
access_conditions,
access_level,
primary_contact_fullname
)
SELECT
'Cyrille_traits',
'Cyrille Violle Trait Database',
1,
'trait',
0,
source_url,
source_citation,
access_conditions,
access_level,
primary_contact_fullname='Cyrille Violle'
FROM :sch_adb.datasource
WHERE proximate_provider_name='Cyrille_traits';
;

-- Populate source-datasource links
INSERT INTO source_datasource (
source_id,
datasource_id,
proximate_provider_datasource_id,
proximate_provider_name
) 
SELECT DISTINCT
source_id,
datasource_id,
proximate_provider_datasource_id,
proximate_provider_name
FROM source a JOIN :sch_adb.datasource b
ON a.source_name=b.source_name
;