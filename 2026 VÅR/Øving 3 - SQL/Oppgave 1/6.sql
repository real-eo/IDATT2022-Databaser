SELECT b.bolag_navn, COUNT(bg.bygn_id) AS antall_bygninger
FROM borettslag b
LEFT JOIN bygning bg ON b.bolag_navn = bg.bolag_navn
GROUP BY b.bolag_navn
ORDER BY b.bolag_navn;