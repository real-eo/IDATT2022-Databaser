SELECT DISTINCT b.bygn_adr
FROM bygning b
JOIN leilighet l ON b.bygn_id = l.bygn_id
WHERE l.ant_rom >= 3;