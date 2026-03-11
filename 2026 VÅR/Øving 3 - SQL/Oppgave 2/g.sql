SELECT DISTINCT l.levby
FROM levinfo l
WHERE l.levnr NOT IN (
  SELECT levnr
  FROM prisinfo
)
AND l.levby NOT IN (
  SELECT DISTINCT l2.levby
  FROM levinfo l2
  WHERE l2.levnr IN (
    SELECT levnr
    FROM prisinfo
  )
);