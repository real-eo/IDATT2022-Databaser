SELECT b.bolag_navn, COUNT(a.and_eier_nr) AS antall_andelseiere
FROM borettslag b
LEFT JOIN andelseier a ON b.bolag_navn = a.bolag_navn
GROUP BY b.bolag_navn
ORDER BY antall_andelseiere DESC;