-- SQLite

INSERT INTO plant_mapping (local_plant_id, external_plant_id) VALUES (1, 101);
INSERT INTO plant_mapping (local_plant_id, external_plant_id) VALUES (2, 102);
INSERT INTO plant_mapping (local_plant_id, external_plant_id) VALUES (3, 103);

SELECT * FROM plant_mapping;

SELECT name FROM sqlite_master WHERE type='table';

SELECT * FROM plant;
-- select plant per id
SELECT * FROM plant WHERE id = 21;

-- delete plant_mapping table
DROP TABLE plant_mapping;