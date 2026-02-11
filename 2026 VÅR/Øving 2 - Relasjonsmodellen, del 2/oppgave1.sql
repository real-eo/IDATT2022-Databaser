-- a)
SELECT fornavn, etternavn FROM FORFATTER ORDER BY etternavn [ASC | DESC];

-- b)
SELECT forlag_id
FROM FORLAG
WHERE forlag_id NOT IN (SELECT forlag_id FROM BOK WHERE forlag_id IS NOT NULL);

-- c)
SELECT *
FROM FORFATTER
WHERE fode_aar < 1900;

-- d) 
SELECT f.forlag_navn, f.adresse
FROM FORLAG f
JOIN BOK b ON f.forlag_id = b.forlag_id
WHERE b.tittel = 'Sult';

-- e) 
SELECT b.tittel
FROM BOK b
JOIN BOK_FORFATTER bf ON b.bok_id = bf.bok_id
JOIN FORFATTER f ON bf.forfatter_id = f.forfatter_id
WHERE f.etternavn = 'Hamsun';

-- f)
SELECT b.tittel, b.utgitt_aar, f.forlag_navn, f.adresse, f.telefon
FROM FORLAG f
LEFT JOIN BOK b ON f.forlag_id = b.forlag_id;