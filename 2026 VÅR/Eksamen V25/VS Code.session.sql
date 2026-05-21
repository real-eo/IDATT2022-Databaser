SELECT BE.beid,   
  CASE
    WHEN SUM(CASE WHEN BT.betypenavn <> 'bryllup' THEN 1 ELSE 0 END) >
         SUM(CASE WHEN BT.betypenavn  = 'bryllup' THEN 1 ELSE 0 END)
    THEN 1 ELSE 0
  END AS oppfyller
FROM       LEVERING   AS L
INNER JOIN BLOMSTER   AS B  ON L.bid = B.bid
INNER JOIN BEGIVENHET AS BE ON L.beid = BE.beid
INNER JOIN BLOMSTTYPE AS BT ON BT.btype = B.btype
WHERE BE.betypenavn = 'bryllup'
GROUP BY BE.beid