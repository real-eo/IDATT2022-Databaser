SELECT p.postnr, p.poststed, COUNT(a.and_eier_nr) AS antall_andelseiere
FROM poststed p
LEFT JOIN bygning b ON p.postnr = b.postnr
LEFT JOIN leilighet l ON b.bygn_id = l.bygn_id
LEFT JOIN andelseier a ON l.and_eier_nr = a.and_eier_nr
GROUP BY p.postnr, p.poststed;