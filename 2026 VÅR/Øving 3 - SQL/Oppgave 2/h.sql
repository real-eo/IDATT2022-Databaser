CREATE VIEW ordre18_mulige AS
SELECT p.levnr,
       od.delnr,
       od.kvantum,
       p.pris,
       od.kvantum * p.pris AS linjesum
FROM ordredetalj od
JOIN prisinfo p ON od.delnr = p.delnr
WHERE od.ordrenr = 18;

SELECT levnr, SUM(linjesum) AS totalbelop
FROM ordre18_mulige
GROUP BY levnr
HAVING COUNT(DISTINCT delnr) = (
  SELECT COUNT(DISTINCT delnr)
  FROM ordredetalj
  WHERE ordrenr = 18
)
ORDER BY totalbelop
LIMIT 1;