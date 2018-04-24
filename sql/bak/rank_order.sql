-- --------------------------------------------------------
-- Adds & populates column 'rank_order' to table nodes
-- --------------------------------------------------------

ALTER TABLE nodes DROP COLUMN IF EXISTS rank_order;
ALTER TABLE nodes ADD COLUMN rank_order numeric default null;

UPDATE nodes a
SET rank_order=
CASE
WHEN rank='superkingdom' THEN 1
WHEN rank='kingdom' THEN 2
WHEN rank='subkingdom' THEN 3
WHEN rank='superphylum' THEN 4
WHEN rank='phylum' THEN 5
WHEN rank='subphylum' THEN 6
WHEN rank='superclass' THEN 7
WHEN rank='class' THEN 8
WHEN rank='infraclass' THEN 9
WHEN rank='subclass' THEN 10
WHEN rank='superorder' THEN 11
WHEN rank='order' THEN 12
WHEN rank='infraorder' THEN 12.2
WHEN rank='parvorder' THEN 12.3
WHEN rank='suborder' THEN 13
WHEN rank='tribe' THEN 14
WHEN rank='subtribe' THEN 15
WHEN rank='superfamily' THEN 16
WHEN rank='family' THEN 17
WHEN rank='subfamily' THEN 18
WHEN rank='genus' THEN 19
WHEN rank='subgenus' THEN 20
WHEN rank='species group' THEN 20.9
WHEN rank='species' THEN 21
WHEN rank='species subgroup' THEN 21.2
WHEN rank='subspecies' THEN 24
WHEN rank='varietas' THEN 24
WHEN rank='forma' THEN 25
WHEN rank='cohort' THEN 12.1
END
; 

CREATE INDEX nodes_rank_order_idx ON nodes (rank_order);