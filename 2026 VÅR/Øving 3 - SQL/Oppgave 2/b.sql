SELECT l.navn, l.levby
FROM levinfo l
JOIN prisinfo p ON l.levnr = p.levnr
WHERE p.delnr = 1;