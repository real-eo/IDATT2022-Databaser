-- Kjor i MySQL 8
-- Lager mye data + spesialdata som matcher oppgavene dine

SET SESSION cte_max_recursion_depth = 20000;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE LEVERING;
TRUNCATE TABLE BEGIVENHET;
TRUNCATE TABLE BLOMSTER;
TRUNCATE TABLE BLOMSTTYPE;
TRUNCATE TABLE STED;
TRUNCATE TABLE BEGIVTYPE;

SET FOREIGN_KEY_CHECKS = 1;

-- 1) Oppslagsdata
INSERT INTO BEGIVTYPE (betypenavn, beskrivelse) VALUES
('bryllup', 'Bryllupsbegivenhet'),
('konfirmasjon', 'Konfirmasjon'),
('begravelse', 'Begravelse'),
('fodselsdag', 'Fodselsdag'),
('jubileum', 'Jubileum');

INSERT INTO STED (stednavn, adresse, postnr, beskrivelse) VALUES
('Ila kirke', 'Mellomila 3', '7018', 'Kirke i Trondheim'),
('Nidarosdomen', 'Kongsgardsgata 2', '7013', 'Domkirke'),
('Lademoen kirke', 'Kirkegata 9', '7043', 'Bykirke'),
('Byaasen kirke', 'Selsbakkvegen 15', '7027', 'Kirke'),
('Moholt selskapslokale', 'Jonsvannsveien 82', '7050', 'Selskapslokale'),
('Solsiden lokale', 'Beddingen 10', '7042', 'Eventlokale'),
('Ranheim kirke', 'Ranheimsvegen 170', '7054', 'Kirke'),
('Lerkendal selskapslokale', 'Klostergata 90', '7030', 'Lokale'),
('Tiller kirke', 'Torvmyra 1', '7091', 'Kirke'),
('Singsaker selskapslokale', 'Rogerts gate 2', '7052', 'Lokale');

INSERT INTO BLOMSTTYPE (btype, typenavn, betypenavn) VALUES
(1,  'Brudebukett klassisk',   'bryllup'),
(2,  'Brudebukett moderne',    'bryllup'),
(3,  'Konfirmasjonsbukett lys','konfirmasjon'),
(4,  'Konfirmasjonsbukett stor','konfirmasjon'),
(5,  'Begravelseskrans hvit',  'begravelse'),
(6,  'Begravelseskrans rod',   'begravelse'),
(7,  'Fodselsdagsbukett fargerik','fodselsdag'),
(8,  'Fodselsdagsbukett premium','fodselsdag'),
(9,  'Jubileumsbukett gull',   'jubileum'),
(10, 'Jubileumsbukett solv',   'jubileum'),
(11, 'Universell bukett liten','bryllup'),
(12, 'Universell bukett stor', 'konfirmasjon');

-- 2) Mange BLOMSTER
INSERT INTO BLOMSTER (bnavn, btype, pris, storrelse, beskrivelse)
WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 1500
)
SELECT
  CONCAT('Bukett ', LPAD(n, 4, '0')) AS bnavn,
  1 + (n % 12) AS btype,
  ROUND(199 + ((n * 17) % 1400) + RAND(n) * 40, 2) AS pris,
  CASE n % 3
    WHEN 0 THEN 'S'
    WHEN 1 THEN 'M'
    ELSE 'L'
  END AS storrelse,
  CONCAT('Auto-generert bukett #', n) AS beskrivelse
FROM seq;

-- 3) Mange BEGIVENHET
INSERT INTO BEGIVENHET (dato, tidspunkt, betypenavn, stednavn, beskrivelse)
WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 2200
)
SELECT
  DATE_ADD('2025-01-01', INTERVAL ((n * 7) % 365) DAY) AS dato,
  SEC_TO_TIME(9 * 3600 + ((n * 13) % 36000)) AS tidspunkt,
  CASE n % 5
    WHEN 0 THEN 'bryllup'
    WHEN 1 THEN 'konfirmasjon'
    WHEN 2 THEN 'begravelse'
    WHEN 3 THEN 'fodselsdag'
    ELSE 'jubileum'
  END AS betypenavn,
  CASE n % 10
    WHEN 0 THEN 'Ila kirke'
    WHEN 1 THEN 'Nidarosdomen'
    WHEN 2 THEN 'Lademoen kirke'
    WHEN 3 THEN 'Byaasen kirke'
    WHEN 4 THEN 'Moholt selskapslokale'
    WHEN 5 THEN 'Solsiden lokale'
    WHEN 6 THEN 'Ranheim kirke'
    WHEN 7 THEN 'Lerkendal selskapslokale'
    WHEN 8 THEN 'Tiller kirke'
    ELSE 'Singsaker selskapslokale'
  END AS stednavn,
  CONCAT('Begivenhet #', n) AS beskrivelse
FROM seq;

-- 4) Garanterte treff for oppgave b/c/d (bryllup i Ila kirke 2025-05-24)
INSERT INTO BEGIVENHET (dato, tidspunkt, betypenavn, stednavn, beskrivelse) VALUES
('2025-05-24', '11:00:00', 'bryllup', 'Ila kirke', 'SP_BRYLLUP_1'),
('2025-05-24', '13:00:00', 'bryllup', 'Ila kirke', 'SP_BRYLLUP_2'),
('2025-05-24', '15:00:00', 'bryllup', 'Ila kirke', 'SP_BRYLLUP_3'),
('2025-05-24', '17:00:00', 'bryllup', 'Ila kirke', 'SP_BRYLLUP_4');

-- 5) Mange LEVERING (robust mot hull i ID-serier)
INSERT INTO LEVERING (bid, beid, kundetelefon)
WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 9000
),
b AS (
  SELECT bid, ROW_NUMBER() OVER (ORDER BY bid) AS rn
  FROM BLOMSTER
),
be AS (
  SELECT beid, ROW_NUMBER() OVER (ORDER BY beid) AS rn
  FROM BEGIVENHET
),
cnt AS (
  SELECT
    (SELECT COUNT(*) FROM BLOMSTER) AS cb,
    (SELECT COUNT(*) FROM BEGIVENHET) AS ce
)
SELECT
  b.bid,
  be.beid,
  CONCAT(
    CASE (seq.n % 3) WHEN 0 THEN '9' WHEN 1 THEN '4' ELSE '8' END,
    LPAD((seq.n * 7919) % 10000000, 7, '0')
  ) AS kundetelefon
FROM seq
CROSS JOIN cnt
JOIN b  ON b.rn  = 1 + MOD(seq.n * 13, cnt.cb)
JOIN be ON be.rn = 1 + MOD(seq.n * 17, cnt.ce);

-- 6) Ekstra kontroll-data for oppgave d:
-- to bryllup med FLERE "ikke-bryllup"-leveranser enn "bryllup"-leveranser
SET @bid_bryllup  := (
  SELECT MIN(b.bid)
  FROM BLOMSTER b
  JOIN BLOMSTTYPE bt ON bt.btype = b.btype
  WHERE bt.betypenavn = 'bryllup'
);

SET @bid_ikke := (
  SELECT MIN(b.bid)
  FROM BLOMSTER b
  JOIN BLOMSTTYPE bt ON bt.btype = b.btype
  WHERE bt.betypenavn <> 'bryllup'
);

SET @be1 := (SELECT beid FROM BEGIVENHET WHERE beskrivelse = 'SP_BRYLLUP_1' LIMIT 1);
SET @be2 := (SELECT beid FROM BEGIVENHET WHERE beskrivelse = 'SP_BRYLLUP_2' LIMIT 1);

-- SP_BRYLLUP_1: 2 bryllup + 4 ikke-bryllup
INSERT INTO LEVERING (bid, beid, kundetelefon) VALUES
(@bid_bryllup, @be1, '90000001'),
(@bid_bryllup, @be1, '90000002'),
(@bid_ikke,    @be1, '90000003'),
(@bid_ikke,    @be1, '90000004'),
(@bid_ikke,    @be1, '90000005'),
(@bid_ikke,    @be1, '90000006');

-- SP_BRYLLUP_2: 1 bryllup + 3 ikke-bryllup
INSERT INTO LEVERING (bid, beid, kundetelefon) VALUES
(@bid_bryllup, @be2, '90000011'),
(@bid_ikke,    @be2, '90000012'),
(@bid_ikke,    @be2, '90000013'),
(@bid_ikke,    @be2, '90000014');