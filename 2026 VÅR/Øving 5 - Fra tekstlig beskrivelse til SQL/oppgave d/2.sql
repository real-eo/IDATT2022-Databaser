SELECT o.oppdragsnr, b.navn, b.telefon
FROM oppdrag o
JOIN bedrift b ON o.orgnr = b.orgnr;