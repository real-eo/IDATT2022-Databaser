SELECT k.kandidatnr,
       k.fornavn,
       k.etternavn,
       q.kvalifikasjonsnr,
       q.beskrivelse
FROM kandidat k
JOIN kandidat_kvalifikasjon kk ON k.kandidatnr = kk.kandidatnr
JOIN kvalifikasjon q ON kk.kvalifikasjonsnr = q.kvalifikasjonsnr;