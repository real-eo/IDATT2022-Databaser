SELECT delnr, levnr
FROM prisinfo
WHERE pris > (
  SELECT pris
  FROM prisinfo
  WHERE katalognr = 'X7770'
);