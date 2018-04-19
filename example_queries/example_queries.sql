-- List all Wordpress users who are also linked to one or more data sets
SELECT fullname, username, email, party_role, 
provider as "BIEN provider", source_name AS dataset, observation_type 
FROM party a JOIN source_party b
ON a.party_id=b.party_id 
JOIN source c
ON b.source_id=c.source_id
WHERE is_wp_user=1
ORDER BY fullname, source_name, party_role
;

-- As above, but only users who are owners of data sets
select fullname, username, email, party_role, 
provider as "BIEN provider", source_name AS dataset, observation_type 
from party a join source_party b
on a.party_id=b.party_id 
join source c
on b.source_id=c.source_id
where is_wp_user=1
and party_role like '%owner%'
order by fullname, source_name, party_role
;

-- Display all users linked to a particular dataset, and their roles
SELECT DISTINCT source_name AS dataset, c.party_id,
fullname as party_name, is_person, party_role AS "role" 
FROM source a JOIN source_party b
ON a.source_id=b.source_id 
JOIN party c
ON b.party_id=c.party_id
WHERE source_name='Brad Boyle Forest Transects'
;

-- Display all people and institutions linked to BIEN data providers
-- The LEFT JOIN reveals that there is still missing information
SELECT DISTINCT source_name AS dataset, c.party_id, 
fullname as party_name, is_person
FROM source a LEFT JOIN source_party b
ON a.source_id=b.source_id 
LEFT JOIN party c
ON b.party_id=c.party_id
WHERE a.is_provider=1
ORDER BY source_name, fullname
;

-- To list users of all component datasets of a provider, search on
-- column provider
SELECT DISTINCT provider, source_name AS dataset, c.party_id,
fullname as party_name, is_person
FROM source a JOIN source_party b
ON a.source_id=b.source_id 
JOIN party c
ON b.party_id=c.party_id
WHERE provider='SALVIAS'
ORDER BY source_name, fullname
;

-- More complete form of the above, using table source_provider.
-- Should only be necessary for some herbarium data
-- sources, which can appear in >1 provider
SELECT DISTINCT e.source_name AS provider, a.source_name AS dataset, 
c.party_id, fullname as party_name, is_person
FROM source a JOIN source_party b
ON a.source_id=b.source_id 
JOIN party c
ON b.party_id=c.party_id
JOIN source_provider d
ON a.source_id=d.source_id
JOIN source e
ON d.provider_source_id=e.source_id
WHERE e.source_name='SALVIAS'
ORDER BY dataset, party_name
;

-- Display all the datasets which a wp user is authorized to view.
-- For now, the listed roles are the only ones in table source_party,
-- however there may be other roles added in future, and not all will
-- authorize a party to view or control access to data.
SELECT DISTINCT c.source_id, provider as "BIEN provider", source_name AS dataset, observation_type 
FROM party a JOIN source_party b
ON a.party_id=b.party_id 
JOIN source c
ON b.source_id=c.source_id
WHERE username='Peet'
AND party_role IN (
'primary contact',
'proximate provider',
'data owner'
)
ORDER BY provider, source_name
;

-- Get datasource IDs of all dataset for which a user has access.
-- Used to retrieve information from the analytical database
-- by joining on datasource_id in various tables.
-- Linking table "source_datasource" is required because table 
-- datasource was not fully normalized; i.e., some datasources 
-- appear >1 time with slightly different information. Table 
-- "source" is fully normalized; each source_name appears only once.
SELECT DISTINCT c.source_id, provider as "BIEN provider", source_name AS dataset, observation_type, d.datasource_id 
FROM party a JOIN source_party b
ON a.party_id=b.party_id 
JOIN source c
ON b.source_id=c.source_id
JOIN source_datasource d
ON c.source_id=d.source_id
WHERE username='Peet'
AND party_role IN (
'primary contact',
'proximate provider',
'data owner'
)
ORDER BY provider, source_name
;

-- More compact form of the above, just retrieves datasource_id
SELECT DISTINCT datasource_id 
FROM party a JOIN source_party b
ON a.party_id=b.party_id 
JOIN source_datasource c
ON b.source_id=c.source_id
WHERE username='Peet'
AND party_role IN (
'primary contact',
'proximate provider',
'data owner'
);
