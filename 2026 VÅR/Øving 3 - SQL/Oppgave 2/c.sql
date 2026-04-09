SELECT l.levnr, l.navn, p.pris
FROM levinfo l
JOIN prisinfo p ON l.levnr = p.levnr
WHERE p.delnr = 201
  AND p.pris = (
    SELECT MIN(pris)
    FROM prisinfo
    WHERE delnr = 201
  );