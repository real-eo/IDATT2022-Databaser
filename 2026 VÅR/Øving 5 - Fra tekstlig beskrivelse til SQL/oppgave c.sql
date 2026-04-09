DROP TABLE IF EXISTS sluttattest;
DROP TABLE IF EXISTS tildeling;
DROP TABLE IF EXISTS kandidat_kvalifikasjon;
DROP TABLE IF EXISTS oppdrag;
DROP TABLE IF EXISTS kandidat;
DROP TABLE IF EXISTS kvalifikasjon;
DROP TABLE IF EXISTS bedrift;

CREATE TABLE kandidat (
  kandidatnr INT NOT NULL AUTO_INCREMENT,
  fornavn VARCHAR(30) NOT NULL,
  etternavn VARCHAR(30) NOT NULL,
  telefon VARCHAR(20),
  epost VARCHAR(50),
  CONSTRAINT kandidat_pk PRIMARY KEY (kandidatnr)
) ENGINE=INNODB;

CREATE TABLE bedrift (
  orgnr CHAR(9) NOT NULL,
  navn VARCHAR(50) NOT NULL,
  telefon VARCHAR(20),
  epost VARCHAR(50),
  CONSTRAINT bedrift_pk PRIMARY KEY (orgnr)
) ENGINE=INNODB;

CREATE TABLE kvalifikasjon (
  kvalifikasjonsnr INT NOT NULL AUTO_INCREMENT,
  beskrivelse VARCHAR(50) NOT NULL,
  CONSTRAINT kvalifikasjon_pk PRIMARY KEY (kvalifikasjonsnr)
) ENGINE=INNODB;

CREATE TABLE oppdrag (
  oppdragsnr INT NOT NULL AUTO_INCREMENT,
  orgnr CHAR(9) NOT NULL,
  kvalifikasjonsnr INT NOT NULL,
  startdato_plan DATE NOT NULL,
  sluttdato_plan DATE NOT NULL,
  CONSTRAINT oppdrag_pk PRIMARY KEY (oppdragsnr),
  CONSTRAINT oppdrag_fk1 FOREIGN KEY (orgnr)
    REFERENCES bedrift(orgnr),
  CONSTRAINT oppdrag_fk2 FOREIGN KEY (kvalifikasjonsnr)
    REFERENCES kvalifikasjon(kvalifikasjonsnr)
) ENGINE=INNODB;

CREATE TABLE kandidat_kvalifikasjon (
  kandidatnr INT NOT NULL,
  kvalifikasjonsnr INT NOT NULL,
  CONSTRAINT kandidat_kvalifikasjon_pk PRIMARY KEY (kandidatnr, kvalifikasjonsnr),
  CONSTRAINT kandidat_kvalifikasjon_fk1 FOREIGN KEY (kandidatnr)
    REFERENCES kandidat(kandidatnr),
  CONSTRAINT kandidat_kvalifikasjon_fk2 FOREIGN KEY (kvalifikasjonsnr)
    REFERENCES kvalifikasjon(kvalifikasjonsnr)
) ENGINE=INNODB;

CREATE TABLE tildeling (
  oppdragsnr INT NOT NULL,
  kandidatnr INT NOT NULL,
  virkelig_startdato DATE,
  virkelig_sluttdato DATE,
  timer_arbeidet DECIMAL(6,2),
  CONSTRAINT tildeling_pk PRIMARY KEY (oppdragsnr),
  CONSTRAINT tildeling_fk1 FOREIGN KEY (oppdragsnr)
    REFERENCES oppdrag(oppdragsnr),
  CONSTRAINT tildeling_fk2 FOREIGN KEY (kandidatnr)
    REFERENCES kandidat(kandidatnr)
) ENGINE=INNODB;

CREATE TABLE sluttattest (
  attestnr INT NOT NULL AUTO_INCREMENT,
  tekstmal TEXT NOT NULL,
  oppdragsnr INT NOT NULL,
  kandidatnr INT NOT NULL,
  CONSTRAINT sluttattest_pk PRIMARY KEY (attestnr),
  CONSTRAINT sluttattest_fk1 FOREIGN KEY (oppdragsnr)
    REFERENCES oppdrag(oppdragsnr),
  CONSTRAINT sluttattest_fk2 FOREIGN KEY (kandidatnr)
    REFERENCES kandidat(kandidatnr)
) ENGINE=INNODB;

-- Testdata

INSERT INTO kandidat (fornavn, etternavn, telefon, epost)
VALUES
('Anne', 'Hansen', '90001111', 'anne@epost.no'),
('Per', 'Olsen', '90002222', 'per@epost.no'),
('Lise', 'Nilsen', '90003333', 'lise@epost.no');

INSERT INTO bedrift (orgnr, navn, telefon, epost)
VALUES
('999111222', 'ByggPartner AS', '73550000', 'post@byggpartner.no'),
('999111333', 'Helsevikar AS', '73551111', 'kontakt@helsevikar.no'),
('999111444', 'Kontorhjelp AS', '73552222', 'hei@kontorhjelp.no');

INSERT INTO kvalifikasjon (beskrivelse)
VALUES
('Truckførerbevis'),
('Sykepleier'),
('Ingen');

INSERT INTO kandidat_kvalifikasjon (kandidatnr, kvalifikasjonsnr)
VALUES
(1, 1),
(2, 2),
(2, 3);

INSERT INTO oppdrag (orgnr, kvalifikasjonsnr, startdato_plan, sluttdato_plan)
VALUES
('999111222', 1, DATE('2026-03-20'), DATE('2026-03-25')),
('999111333', 2, DATE('2026-03-21'), DATE('2026-04-10')),
('999111444', 3, DATE('2026-03-22'), DATE('2026-03-23'));

-- Ett avsluttet oppdrag
INSERT INTO tildeling (oppdragsnr, kandidatnr, virkelig_startdato, virkelig_sluttdato, timer_arbeidet)
VALUES
(1, 1, DATE('2026-03-20'), DATE('2026-03-25'), 37.5);

-- Ett pågående / ikke ferdig registrert oppdrag
INSERT INTO tildeling (oppdragsnr, kandidatnr, virkelig_startdato, virkelig_sluttdato, timer_arbeidet)
VALUES
(2, 2, DATE('2026-03-21'), NULL, NULL);

INSERT INTO sluttattest (tekstmal, oppdragsnr, kandidatnr)
VALUES
('Vi bekrefter at kandidaten har fullført oppdraget på en tilfredsstillende måte.', 1, 1);