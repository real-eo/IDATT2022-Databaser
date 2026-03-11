SELECT COUNT(*) AS antall_leiligheter
FROM leilighet l
JOIN bygning b ON l.bygn_id = b.bygn_id
WHERE b.bolag_navn = 'Tertitten';