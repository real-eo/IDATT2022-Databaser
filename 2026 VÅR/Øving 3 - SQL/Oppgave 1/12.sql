SELECT DISTINCT b.bolag_navn
FROM bygning b
JOIN leilighet l ON b.bygn_id = l.bygn_id
WHERE l.ant_rom = 4;