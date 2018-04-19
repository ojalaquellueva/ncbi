-- --------------------------------------------------------
-- --------------------------------------------------------
-- Inserts links between sources which are datasets only,
-- to sources which are the proximate providers to BIEN
-- Needs to be in separate table as some sources are shared
-- by >1 provider
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- Insert distinct sources
INSERT INTO source_provider (
source_id,
provider_source_id
)
SELECT DISTINCT
a.source_id,
d.source_id
FROM source a JOIN :sch_adb.datasource b
ON a.source_name=b.source_name
JOIN :sch_adb.datasource c
ON b.proximate_provider_datasource_id=c.datasource_id
JOIN source d 
ON c.source_name=d.source_name
;

-- Insert proximate provider for traits dataset
INSERT INTO source_provider (
source_id,
provider_source_id
)
SELECT
source_id,
source_id
FROM source
WHERE source_name='Cyrille_traits'
;


-- Add main provider to source table 
-- Will be incomplete for datasets from >1 source, but whatever
UPDATE source a
SET 
provider=c.source_name,
provider_source_id=c.source_id
FROM source_provider b JOIN source c
ON b.provider_source_id=c.source_id
WHERE a.source_id=b.source_id
;
