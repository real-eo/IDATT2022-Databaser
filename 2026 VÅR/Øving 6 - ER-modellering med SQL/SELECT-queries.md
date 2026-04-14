# Oppgave 2 - SQL (SELECT-queries)

## 1) Antall stolmodeller per stoltype
```sql
SELECT
	stoltype,
	COUNT(*) AS antall_stolmodeller
FROM Stolmodell
GROUP BY stoltype;
```

## 2) Gjennomsnittlig antall bestilte stoler per stoltype
```sql
SELECT
	sm.stoltype,
	AVG(ol.antall) AS gjennomsnitt_antall_bestilt
FROM Ordrelinje ol
JOIN Stolmodell sm ON sm.modell = ol.modell
GROUP BY sm.stoltype;
```

## 3) Totalt antall stoler i bestillinger som ikke er levert
```sql
SELECT
	SUM(ol.antall) AS totalt_ikke_levert
FROM Ordrelinje ol
JOIN Ordre o ON o.ordrenummer = ol.ordrenummer
WHERE o.reell_leveringsdato IS NULL;
```

## 4) Antall av stolene i (3) som er standardstoler
```sql
SELECT
	SUM(ol.antall) AS standardstoler_ikke_levert
FROM Ordrelinje ol
JOIN Ordre o ON o.ordrenummer = ol.ordrenummer
JOIN Stolmodell sm ON sm.modell = ol.modell
WHERE o.reell_leveringsdato IS NULL
  AND sm.er_standard = TRUE;
```