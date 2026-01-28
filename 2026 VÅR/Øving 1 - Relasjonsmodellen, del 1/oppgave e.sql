-- 1. bygning.borettslag_id
ALTER TABLE bygning 
ADD CONSTRAINT bygning_fk FOREIGN KEY (borettslag_id) 
    REFERENCES borettslag(borettslag_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- 2. leilighet.bygning_id
ALTER TABLE leilighet 
ADD CONSTRAINT leilighet_bygning_fk FOREIGN KEY (bygning_id) 
    REFERENCES bygning(bygning_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- 3. leilighet.andelseier_id
ALTER TABLE leilighet 
ADD CONSTRAINT leilighet_andelseier_fk FOREIGN KEY (andelseier_id) 
    REFERENCES andelseier(andelseier_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;