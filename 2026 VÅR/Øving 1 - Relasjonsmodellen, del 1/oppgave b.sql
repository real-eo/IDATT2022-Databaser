-- Opprett database (hvis nødvendig)
CREATE DATABASE IF NOT EXISTS bygg_bo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bygg_bo;

-- Tabell for borettslag
CREATE TABLE borettslag (
    borettslag_id INT AUTO_INCREMENT,
    navn VARCHAR(100) NOT NULL,
    adresse VARCHAR(200) NOT NULL,
    antall_enheter INT NOT NULL,
    etableringsaar YEAR NOT NULL,
    PRIMARY KEY (borettslag_id)
);

-- Tabell for bygninger
CREATE TABLE bygning (
    bygning_id INT AUTO_INCREMENT,
    borettslag_id INT NOT NULL,
    adresse VARCHAR(200) NOT NULL,
    antall_etasjer INT NOT NULL,
    antall_leiligheter INT NOT NULL,
    PRIMARY KEY (bygning_id),
    CONSTRAINT bygning_fk FOREIGN KEY (borettslag_id) 
        REFERENCES borettslag(borettslag_id)
);

-- Tabell for andelseiere
CREATE TABLE andelseier (
    andelseier_id INT AUTO_INCREMENT,
    fornavn VARCHAR(50) NOT NULL,
    etternavn VARCHAR(50) NOT NULL,
    telefon VARCHAR(20),
    epost VARCHAR(100),
    fodselsdato DATE,
    PRIMARY KEY (andelseier_id)
);

-- Tabell for leiligheter
CREATE TABLE leilighet (
    leilighet_id INT AUTO_INCREMENT,
    bygning_id INT NOT NULL,
    leilighetsnummer VARCHAR(10) NOT NULL,
    antall_rom INT NOT NULL,
    antall_kvm DECIMAL(6,2) NOT NULL,
    etasje INT NOT NULL,
    andelseier_id INT,
    PRIMARY KEY (leilighet_id),
    CONSTRAINT leilighet_bygning_fk FOREIGN KEY (bygning_id) 
        REFERENCES bygning(bygning_id),
    CONSTRAINT leilighet_andelseier_fk FOREIGN KEY (andelseier_id) 
        REFERENCES andelseier(andelseier_id)
);