SELECT p.postnr, p.poststed, COUNT(a.and_eier_nr) AS antall_andelseiere
FROM poststed p
JOIN bygning b ON p.postnr = b.postnr
JOIN leilighet l ON b.bygn_id = l.bygn_id
JOIN andelseier a ON l.and_eier_nr = a.and_eier_nr
GROUP BY p.postnr, p.poststed;