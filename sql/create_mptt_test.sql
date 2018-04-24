-- --------------------------------------------------------
-- Generate table of small phylogeny for testing
-- mptt index functions
-- --------------------------------------------------------

DROP TABLE IF EXISTS mptt_test CASCADE;
CREATE TABLE mptt_test (
tax_id bigint default null,
parent_tax_id bigint default null,
rank text default null,
scientific_name text default null,
left_index bigint default null,
right_index bigint default null
);

INSERT INTO mptt_test 
(tax_id, parent_tax_id, rank, scientific_name)
VALUES 
('1', '1', NULL, 'root'),
('2', '1', NULL, 'E'),
('3', '2', NULL, 'D'),
('4', '3', NULL, 'A'),
('5', '3', NULL, 'B'),
('6', '2', NULL, 'C')
;