-- GYLDIGE INSERT-setninger

-- Sett inn borettslag
INSERT INTO borettslag (navn, adresse, antall_enheter, etableringsaar) 
VALUES ('Solsiden Bo', 'Solveien 1, 7050 Trondheim', 45, 2010);

INSERT INTO borettslag (navn, adresse, antall_enheter, etableringsaar) 
VALUES ('Fjellhøyden', 'Fjellveien 20, 7020 Trondheim', 32, 2015);

-- Sett inn bygninger
INSERT INTO bygning (borettslag_id, adresse, antall_etasjer, antall_leiligheter) 
VALUES (1, 'Solveien 1A, 7050 Trondheim', 4, 16);

INSERT INTO bygning (borettslag_id, adresse, antall_etasjer, antall_leiligheter) 
VALUES (1, 'Solveien 1B, 7050 Trondheim', 5, 20);

INSERT INTO bygning (borettslag_id, adresse, antall_etasjer, antall_leiligheter) 
VALUES (2, 'Fjellveien 20A, 7020 Trondheim', 3, 12);

-- Sett inn andelseiere
INSERT INTO andelseier (fornavn, etternavn, telefon, epost, fodselsdato) 
VALUES ('Kari', 'Nordmann', '95012345', 'kari.nordmann@epost.no', '1985-03-15');

INSERT INTO andelseier (fornavn, etternavn, telefon, epost, fodselsdato) 
VALUES ('Ola', 'Hansen', '98765432', 'ola.hansen@epost.no', '1978-11-22');

INSERT INTO andelseier (fornavn, etternavn, telefon, epost, fodselsdato) 
VALUES ('Anne', 'Olsen', '91122334', 'anne.olsen@epost.no', '1992-07-08');

-- Sett inn leiligheter (noen med eiere, noen uten)
INSERT INTO leilighet (bygning_id, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id) 
VALUES (1, '101', 3, 65.5, 1, 1);

INSERT INTO leilighet (bygning_id, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id) 
VALUES (1, '201', 4, 85.0, 2, 2);

INSERT INTO leilighet (bygning_id, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id) 
VALUES (2, '101', 2, 45.0, 1, NULL); -- Leilighet uten eier

INSERT INTO leilighet (bygning_id, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id) 
VALUES (3, '301', 3, 72.5, 3, 3);


-- UGYLDIGE INSERT-setninger (brudd på integritetsregler)

-- 1) Brudd på entitetsintegritet (primærnøkkel kan ikke være NULL)
INSERT INTO borettslag (borettslag_id, navn, adresse, antall_enheter, etableringsaar) 
VALUES (NULL, 'Test Bo', 'Testveien 1', 10, 2020);
-- Feil: Primary key cannot be NULL

-- 2) Brudd på entitetsintegritet (duplikat primærnøkkel)
INSERT INTO andelseier (andelseier_id, fornavn, etternavn, telefon, epost, fodselsdato) 
VALUES (1, 'Test', 'Testesen', '99999999', 'test@test.no', '1990-01-01');
-- Feil: Duplicate entry '1' for key 'PRIMARY'

-- 3) Brudd på referanseintegritet (fremmednøkkel refererer til ikke-eksisterende verdi)
INSERT INTO bygning (borettslag_id, adresse, antall_etasjer, antall_leiligheter) 
VALUES (999, 'Fantomveien 1', 5, 20);
-- Feil: Cannot add or update a child row: a foreign key constraint fails

-- 4) Brudd på referanseintegritet (ugyldig andelseier_id)
INSERT INTO leilighet (bygning_id, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id) 
VALUES (1, '401', 3, 70.0, 4, 999);
-- Feil: Cannot add or update a child row: a foreign key constraint fails

-- 5) Brudd på referanseintegritet (ugyldig bygning_id)
INSERT INTO leilighet (bygning_id, leilighetsnummer, antall_rom, antall_kvm, etasje, andelseier_id) 
VALUES (999, '101', 2, 50.0, 1, 1);
-- Feil: Cannot add or update a child row: a foreign key constraint fails