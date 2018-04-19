-- --------------------------------------------------------
-- --------------------------------------------------------
-- Updates key links between sources and parties
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS source_party_temp;
CREATE TABLE source_party_temp (
party_id integer default null,
source_id integer default null,
party_role text default null,
access_conditions text default null
);

-- Insert existing links
INSERT INTO source_party_temp (
party_id,
source_id,
party_role
)
SELECT DISTINCT
party_id,
source_id,
party_role
FROM source_party
;

-- Update access conditions
-- This way avoids anomalies
UPDATE source_party_temp a
SET access_conditions=b.access_conditions
FROM source_party b 
WHERE a.party_id=b.party_id
AND a.source_id=b.source_id
AND a.party_role=b.party_role
;

-- Update ids for synonym names
UPDATE source_party_temp a
SET party_id=c.party_id
FROM party b JOIN party c
ON b.accepted_party_id=c.party_id
WHERE a.party_id=b.party_id
;

-- Primary contacts (and possibly data owner) for 
-- datasets which are also providers
INSERT INTO source_party_temp (
source_id,
party_id,
party_role
)
VALUES
(
(select source_id from source where source_name='NY'),
(SELECT party_id FROM party WHERE fullname='Barbara Thiers'),
'primary contact'
),
(
(select source_id from source where source_name='NY'),
(SELECT party_id FROM party WHERE fullname='Barbara Thiers'),
'data owner'
),
(
(select source_id from source where source_name='CTFS'),
(SELECT party_id FROM party WHERE fullname='Richard Condit' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='CTFS'),
(SELECT party_id FROM party WHERE fullname='Richard Condit' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='CVS'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='CVS'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='NCU'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='NCU'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='UNCC'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='UNCC'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='VegBank'),
(SELECT party_id FROM party WHERE fullname='Robert Peet' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Cyrille_traits'),
(SELECT party_id FROM party WHERE fullname='Cyrille Violle' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Cyrille_traits'),
(SELECT party_id FROM party WHERE fullname='Cyrille Violle' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Madidi'),
(SELECT party_id FROM party WHERE fullname='Peter Jorgensen' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Madidi'),
(SELECT party_id FROM party WHERE fullname='Peter Jorgensen' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='NVS'),
(SELECT party_id FROM party WHERE fullname='Susan Wiser' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='NVS'),
(SELECT party_id FROM party WHERE fullname='Susan Wiser' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='SALVIAS'),
(SELECT party_id FROM party WHERE fullname='Brad Boyle' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='SALVIAS'),
(SELECT party_id FROM party WHERE fullname='Brad Boyle' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='SALVIAS'),
(SELECT party_id FROM party WHERE fullname='Brian Enquist' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='SALVIAS'),
(SELECT party_id FROM party WHERE fullname='Brian Enquist' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='TEAM'),
(SELECT party_id FROM party WHERE fullname='Tom Lacher' AND accepted_party_id IS NULL),
'primary contact'
)
;

-- Data owner of non-provider plot datasets 
INSERT INTO source_party_temp (
source_id,
party_id,
party_role
)
VALUES
(
(select source_id from source where source_name='Bonifacino Forest Transects'),
(SELECT party_id FROM party WHERE fullname='Mauricio Bonifacino' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Bonifacino Forest Transects'),
(SELECT party_id FROM party WHERE fullname='Mauricio Bonifacino' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Brad Boyle Forest Transects'),
(SELECT party_id FROM party WHERE fullname='Brad Boyle' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Brad Boyle Forest Transects'),
(SELECT party_id FROM party WHERE fullname='Brad Boyle' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Cam Webb Borneo Plots'),
(SELECT party_id FROM party WHERE fullname='Cam Webb' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Cam Webb Borneo Plots'),
(SELECT party_id FROM party WHERE fullname='Cam Webb' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='DeWalt Bolivia forest plots'),
(SELECT party_id FROM party WHERE fullname='Saara J. DeWalt' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='DeWalt Bolivia forest plots'),
(SELECT party_id FROM party WHERE fullname='Saara J. DeWalt' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Gentry Transect Dataset'),
(SELECT party_id FROM party WHERE fullname='Missouri Botanical Garden,Herbarium' AND accepted_party_id IS NULL),
'proximate provider'
),
(
(select source_id from source where source_name='Gentry Transect Dataset'),
(SELECT party_id FROM party WHERE fullname='Missouri Botanical Garden,Herbarium' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='La Selva Secondary Forest Plots'),
(SELECT party_id FROM party WHERE fullname='Susan Letcher' AND accepted_party_id IS NULL),
'proximate provider'
),
(
(select source_id from source where source_name='La Selva Secondary Forest Plots'),
(SELECT party_id FROM party WHERE fullname='Susan Letcher' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='La Selva Secondary Forest Plots'),
(SELECT party_id FROM party WHERE fullname='Susan Letcher' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Noel Kempff Forest Plots'),
(SELECT party_id FROM party WHERE fullname='Tim Killeen' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Noel Kempff Forest Plots'),
(SELECT party_id FROM party WHERE fullname='Tim Killeen' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Noel Kempff Savanna Plots'),
(SELECT party_id FROM party WHERE fullname='Tim Killeen' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Noel Kempff Savanna Plots'),
(SELECT party_id FROM party WHERE fullname='Tim Killeen' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='Pilon Lajas Treeplots Bolivia'),
(SELECT party_id FROM party WHERE fullname='Tim Killeen' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='Pilon Lajas Treeplots Bolivia'),
(SELECT party_id FROM party WHERE fullname='Tim Killeen' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='RAINFOR - 0.1 ha Madre de Dios, Peru'),
(SELECT party_id FROM party WHERE fullname='Oliver Phillips' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='RAINFOR - 0.1 ha Madre de Dios, Peru'),
(SELECT party_id FROM party WHERE fullname='Oliver Phillips' AND accepted_party_id IS NULL),
'data owner'
),
(
(select source_id from source where source_name='RAINFOR - 1 ha Peru'),
(SELECT party_id FROM party WHERE fullname='Oliver Phillips' AND accepted_party_id IS NULL),
'primary contact'
),
(
(select source_id from source where source_name='RAINFOR - 1 ha Peru'),
(SELECT party_id FROM party WHERE fullname='Oliver Phillips' AND accepted_party_id IS NULL),
'data owner'
)
;

-- Insert all sources for administrators
INSERT INTO source_party_temp (
source_id,
party_id,
party_role
)
SELECT source_id,
(SELECT party_id FROM party WHERE fullname='Brad Boyle' AND accepted_party_id IS NULL),
'administrator'
FROM source
;

INSERT INTO source_party_temp (
source_id,
party_id,
party_role
)
SELECT source_id,
(SELECT party_id FROM party WHERE fullname='Jeanine K. McGann' AND accepted_party_id IS NULL),
'administrator'
FROM source
;

TRUNCATE source_party;

INSERT INTO source_party (
party_id,
source_id,
party_role,
access_conditions
)
SELECT DISTINCT
party_id,
source_id,
party_role,
access_conditions
FROM source_party_temp
;

UPDATE source_party
SET is_primary=1 
WHERE party_role='primary contact'
;

-- Clean up
DROP TABLE source_party_temp;


