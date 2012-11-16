
/*
alter table asset.call_number disable rule
alter table asset.copy disable rule...
delete from asset.copy;
delete from asset.call_number;
alter table asset.call_number enable rule
alter table asset.copy enable rule...
*/

-- two utility functions

CREATE FUNCTION evergreen.populate_call_number (ownlib INTEGER, label TEXT)
RETURNS void AS $$
    INSERT INTO asset.call_number (record, creator, editor, owning_lib, label, label_class)
        SELECT id, 1, 1, $1, $2 || id::text, 1
        FROM biblio.record_entry
        WHERE id > 0;
$$ LANGUAGE SQL;

CREATE FUNCTION evergreen.populate_copy (circlib INTEGER, ownlib INTEGER, barcode TEXT, label TEXT)
RETURNS void AS $$
    INSERT INTO asset.copy (call_number, circ_lib, creator, editor, loan_duration, fine_level, barcode)
        SELECT id, $1, 1, 1, 1, 1, $3 || id::text
        FROM asset.call_number
        WHERE record > 0 AND label LIKE $4 || '%' AND owning_lib = $2;
$$ LANGUAGE SQL;

-- Create call numbers
SELECT evergreen.populate_call_number(4, 'cnDemo_'); -- BR1
SELECT evergreen.populate_call_number(5, 'cnDemo_'); -- BR2
SELECT evergreen.populate_call_number(6, 'cnDemo_'); -- BR3
SELECT evergreen.populate_call_number(7, 'cnDemo_'); -- BR4
SELECT evergreen.populate_call_number(9, 'cnDemo_'); -- BM1
-- SELECT evergreen.populate_call_number(4, 'PERFORM '); -- BR1
-- SELECT evergreen.populate_call_number(5, 'PERFORM '); -- BR2
-- SELECT evergreen.populate_call_number(6, 'PERFORM '); -- BR3
-- SELECT evergreen.populate_call_number(7, 'PERFORM '); -- BR4
-- SELECT evergreen.populate_call_number(9, 'PERFORM '); -- BM1

-- Create copies - takes about 3 minutes each
SELECT evergreen.populate_copy(4, 4, 'coDemo_40_', 'cnDemo_'); -- BR1
SELECT evergreen.populate_copy(5, 5, 'coDemo_50_', 'cnDemo_'); -- BR2
SELECT evergreen.populate_copy(6, 6, 'coDemo_60_', 'cnDemo_'); -- BR3
SELECT evergreen.populate_copy(7, 7, 'coDemo_70_', 'cnDemo_'); -- BR4
SELECT evergreen.populate_copy(9, 9, 'coDemo_90_', 'cnDemo_'); -- BM1

SELECT evergreen.populate_copy(4, 4, 'coDemo_41_', 'cnDemo_'); -- BR1
SELECT evergreen.populate_copy(5, 5, 'coDemo_51_', 'cnDemo_'); -- BR2
SELECT evergreen.populate_copy(6, 6, 'coDemo_61_', 'cnDemo_'); -- BR3
SELECT evergreen.populate_copy(7, 7, 'coDemo_71_', 'cnDemo_'); -- BR4
SELECT evergreen.populate_copy(9, 9, 'coDemo_91_', 'cnDemo_'); -- BM1

-- SELECT evergreen.populate_copy(4, 4, 'CONC42000', 'CONCERTO'); -- BR1
-- SELECT evergreen.populate_copy(5, 5, 'CONC52000', 'CONCERTO'); -- BR2
-- SELECT evergreen.populate_copy(6, 6, 'CONC62000', 'CONCERTO'); -- BR3
-- SELECT evergreen.populate_copy(7, 7, 'CONC72000', 'CONCERTO'); -- BR4
-- SELECT evergreen.populate_copy(9, 9, 'CONC92000', 'CONCERTO'); -- BM1
--
-- SELECT evergreen.populate_copy(4, 4, 'CONC43000', 'CONCERTO'); -- BR1
-- SELECT evergreen.populate_copy(5, 5, 'CONC53000', 'CONCERTO'); -- BR2
-- SELECT evergreen.populate_copy(6, 6, 'CONC63000', 'CONCERTO'); -- BR3
-- SELECT evergreen.populate_copy(7, 7, 'CONC73000', 'CONCERTO'); -- BR4
-- SELECT evergreen.populate_copy(9, 9, 'CONC93000', 'CONCERTO'); -- BM1
--
-- SELECT evergreen.populate_copy(4, 4, 'CONC44000', 'CONCERTO'); -- BR1
-- SELECT evergreen.populate_copy(5, 5, 'CONC54000', 'CONCERTO'); -- BR2
-- SELECT evergreen.populate_copy(6, 6, 'CONC64000', 'CONCERTO'); -- BR3
-- SELECT evergreen.populate_copy(7, 7, 'CONC74000', 'CONCERTO'); -- BR4
-- SELECT evergreen.populate_copy(9, 9, 'CONC94000', 'CONCERTO'); -- BM1
--
-- SELECT evergreen.populate_copy(4, 4, 'CONC40000', 'PERFORM'); -- BR1
-- SELECT evergreen.populate_copy(5, 5, 'CONC50000', 'PERFORM'); -- BR2
-- SELECT evergreen.populate_copy(6, 6, 'CONC60000', 'PERFORM'); -- BR3
-- SELECT evergreen.populate_copy(7, 7, 'CONC70000', 'PERFORM'); -- BR4
-- SELECT evergreen.populate_copy(9, 9, 'CONC90000', 'PERFORM'); -- BM1
--
-- SELECT evergreen.populate_copy(4, 4, 'CONC41000', 'PERFORM'); -- BR1
-- SELECT evergreen.populate_copy(5, 5, 'CONC51000', 'PERFORM'); -- BR2
-- SELECT evergreen.populate_copy(6, 6, 'CONC61000', 'PERFORM'); -- BR3
-- SELECT evergreen.populate_copy(7, 7, 'CONC71000', 'PERFORM'); -- BR4
-- SELECT evergreen.populate_copy(9, 9, 'CONC91000', 'PERFORM'); -- BM1

-- Delete some copies, call numbers, and bib records
-- DELETE FROM biblio.record_entry
--     WHERE id IN (10, 20);
--
-- DELETE FROM asset.call_number
--     WHERE record IN (30, 40) AND owning_lib = 4;
--
-- DELETE FROM asset.copy
--     WHERE call_number IN (
--         SELECT id FROM asset.call_number
--             WHERE record IN (50, 60)
--     ) AND circ_lib = 5;
--
-- -- Add some prefixes and suffixes
-- INSERT INTO asset.call_number_prefix (owning_lib, label) VALUES
--     (4, 'REF BR1'), (5, 'DVD BR2'), (7, 'STORAGE BR4');
--
-- INSERT INTO asset.call_number_suffix (owning_lib, label) VALUES
--     (4, 'REFERENCE'), (5, 'MEDIA'), (7, 'DEPOSITORY');
--
-- -- Some call numbers will have both prefixes and suffixes
-- UPDATE asset.call_number
--     SET prefix = 1, suffix = 1
--     WHERE owning_lib = 4 AND record IN (35, 45);
--
-- UPDATE asset.call_number
--     SET prefix = 2, suffix = 2
--     WHERE owning_lib = 5 AND record IN (55, 65);
--
-- -- Some call numbers will have either a prefix or a suffix
-- UPDATE asset.call_number
--     SET prefix = 3
--     WHERE owning_lib = 7 AND record IN (75);
--
-- UPDATE asset.call_number
--     SET suffix = 3
--     WHERE owning_lib = 7 AND record IN (85);
--
-- -- Create some bibliographic parts
-- INSERT INTO biblio.monograph_part (record, label) VALUES
--     -- "Virtuoso wind concertos"
--     (84, 'DISC 1'), (84, 'DISC 2'), (84, 'DISC 3'), (84, 'DISC 4'),
--     -- "6 double concertos"
--     (53, 'DISC 1'), (53, 'DISC 2'), (53, 'DISC 3'), (53, 'DISC 4');
--
-- -- Create additional copies for the parts
-- INSERT INTO asset.copy (call_number, circ_lib, creator, editor, loan_duration, fine_level, barcode)
--     SELECT id, owning_lib, 1, 1, 1, 1, 'CONC70001' || id::text
--     FROM asset.call_number
--     WHERE record IN (53, 84) AND label LIKE 'CONCERTO %' AND owning_lib = 7;
--
-- INSERT INTO asset.copy (call_number, circ_lib, creator, editor, loan_duration, fine_level, barcode)
--     SELECT id, owning_lib, 1, 1, 1, 1, 'CONC70002' || id::text
--     FROM asset.call_number
--     WHERE record IN (53, 84) AND label LIKE 'CONCERTO %' AND owning_lib = 7;
--
-- -- Assign the copies to the parts
-- INSERT INTO asset.copy_part_map (target_copy, part)
--     SELECT DISTINCT ON (ac.id) ac.id, bmp.id
--     FROM asset.copy ac INNER JOIN asset.call_number acn
--             ON ac.call_number = acn.id
--         INNER JOIN biblio.monograph_part bmp
--             ON acn.record = bmp.record
--     WHERE bmp.record IN (53, 84)
--         AND ac.circ_lib = 7;
--
-- -- Create some conjoined items:
-- -- Create a new conjoined item type
-- INSERT INTO biblio.peer_type (name)
--     VALUES ('Media player');

-- Create additional copies for the conjoined items
-- INSERT INTO asset.copy (call_number, circ_lib, creator, editor, loan_duration, fine_level, barcode)
--     SELECT id, owning_lib, 1, 1, 1, 1, 'PEERBIB' || record::text
--     FROM asset.call_number
--     WHERE record = 15 AND label LIKE 'CONCERTO %' AND owning_lib = 4;

-- Create the peer bib copy map
-- INSERT INTO biblio.peer_bib_copy_map (peer_type, peer_record, target_copy)
--     SELECT bpt.id, acn.record, ac.id
--     FROM biblio.peer_type bpt
--         INNER JOIN asset.copy ac ON bpt.name = 'Media player'
--         INNER JOIN asset.call_number acn ON ac.barcode LIKE 'PEERBIB%'
--         AND ac.circ_lib = 4
--         AND acn.record IN (24, 93, 97, 100)
--     GROUP BY bpt.id, acn.record, ac.id;

DROP TABLE marcxml_import;
DROP FUNCTION evergreen.populate_call_number(INTEGER, TEXT);
DROP FUNCTION evergreen.populate_copy(INTEGER, INTEGER, TEXT, TEXT);
