-- --------------------------------------------------------
-- Add mptt index columns to table
-- --------------------------------------------------------

ALTER TABLE :tbl DROP COLUMN IF EXISTS :lcol;
ALTER TABLE :tbl DROP COLUMN IF EXISTS :rcol;

ALTER TABLE :tbl ADD COLUMN :lcol bigint default null;
ALTER TABLE :tbl ADD COLUMN :rcol bigint default null;
