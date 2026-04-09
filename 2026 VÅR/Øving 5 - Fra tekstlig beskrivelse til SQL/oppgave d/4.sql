SELECT k.kandidatnr,
       k.fornavn,
       k.etternavn,
       q.kvalifikasjonsnr,
       q.beskrivelse
FROM kandidat k
LEFT JOIN kandidat_kvalifikasjon kk ON k.kandidatnr = kk.kandidatnr
LEFT JOIN kvalifikasjon q ON kk.kvalifikasjonsnr = q.kvalifikasjonsnr;