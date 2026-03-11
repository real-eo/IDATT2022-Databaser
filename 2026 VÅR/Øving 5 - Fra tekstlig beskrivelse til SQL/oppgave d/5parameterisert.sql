SELECT k.fornavn,
       k.etternavn,
       t.virkelig_sluttdato,
       o.oppdragsnr,
       b.navn AS bedriftsnavn
FROM kandidat k
JOIN tildeling t ON k.kandidatnr = t.kandidatnr
JOIN oppdrag o ON t.oppdragsnr = o.oppdragsnr
JOIN bedrift b ON o.orgnr = b.orgnr
WHERE k.kandidatnr = ?;