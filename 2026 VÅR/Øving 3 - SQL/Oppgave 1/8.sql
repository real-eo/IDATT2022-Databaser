SELECT MAX(l.etasje) AS hoyeste_etasje
FROM leilighet l
JOIN bygning b ON l.bygn_id = b.bygn_id
WHERE b.bolag_navn = 'Tertitten';