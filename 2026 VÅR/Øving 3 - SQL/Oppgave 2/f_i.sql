CREATE TABLE byfylke (
  levby VARCHAR(20) NOT NULL,
  fylke VARCHAR(20) NOT NULL,
  CONSTRAINT byfylke_pk PRIMARY KEY (levby)
) ENGINE=INNODB;

INSERT INTO byfylke (levby, fylke)
SELECT DISTINCT levby, fylke
FROM levinfo;

CREATE TABLE levinfo2 (
  levnr INTEGER,
  navn VARCHAR(20) NOT NULL,
  adresse VARCHAR(20) NOT NULL,
  levby VARCHAR(20) NOT NULL,
  postnr INTEGER NOT NULL,
  CONSTRAINT levinfo2_pk PRIMARY KEY (levnr),
  CONSTRAINT levinfo2_fk FOREIGN KEY (levby) REFERENCES byfylke(levby)
) ENGINE=INNODB;

INSERT INTO levinfo2 (levnr, navn, adresse, levby, postnr)
SELECT levnr, navn, adresse, levby, postnr
FROM levinfo;
