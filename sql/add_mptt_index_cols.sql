-- --------------------------------------------------------
-- Add mptt index columns to table nodes
-- --------------------------------------------------------

ALTER TABLE nodes DROP COLUMN IF EXISTS left_index;
ALTER TABLE nodes DROP COLUMN IF EXISTS right_index;

ALTER TABLE nodes ADD COLUMN left_index bigint default null;
ALTER TABLE nodes ADD COLUMN right_index bigint default null;
