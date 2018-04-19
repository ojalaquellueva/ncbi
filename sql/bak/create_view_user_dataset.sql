-- --------------------------------------------------------
-- --------------------------------------------------------
-- Creates view which lists all datasets to which a user 
-- is linked, either directly or via their link to a 
-- proximate provider
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- Update existing users
DROP VIEW IF EXISTS user_dataset;
CREATE VIEW user_dataset AS
SELECT DISTINCT * FROM
(
SELECT DISTINCT a.username, c.source_id, d.datasource_id, d.proximate_provider_name AS provider, source_name, source_fullname, observation_type
FROM users.party a JOIN users.source_party b
ON a.party_id=b.party_id
JOIN users.source c
ON b.source_id=c.source_id
JOIN users.source_datasource d
ON c.source_id=d.source_id
WHERE a.is_wp_user=1 
AND party_role IN (
'primary contact',
'proximate provider',
'data owner',
'administrator'
)
AND is_provider=0
UNION ALL
SELECT DISTINCT e.username, c.source_id, d.datasource_id, d.proximate_provider_name AS provider, source_name, source_fullname, observation_type
FROM users.source c JOIN users.source_datasource d
ON c.source_id=d.source_id
JOIN (
SELECT DISTINCT a.username, c.source_id AS provider_source_id
FROM users.party a JOIN users.source_party b
ON a.party_id=b.party_id
JOIN users.source c
ON b.source_id=c.source_id
JOIN users.source_datasource d
ON c.source_id=d.source_id
WHERE a.is_wp_user=1 
AND party_role IN (
'primary contact',
'proximate provider',
'data owner',
'administrator'
)
AND is_provider=1
) AS e
ON c.provider_source_id=e.provider_source_id
) AS a
ORDER BY provider, source_name
;

