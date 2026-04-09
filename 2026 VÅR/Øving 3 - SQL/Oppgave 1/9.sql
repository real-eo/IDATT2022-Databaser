SELECT a.and_eier_nr, a.fornavn, a.etternavn
FROM andelseier a
LEFT JOIN leilighet l ON a.and_eier_nr = l.and_eier_nr
WHERE l.leil_nr IS NULL;